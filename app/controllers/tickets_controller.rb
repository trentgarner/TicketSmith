class TicketsController < ApplicationController
  FILTER_KEYS = %w[q status priority assignee].freeze
  LIST_LIMIT = 10
  BOARD_LIMIT_DEFAULT = 10
  WIP_LIMIT = 3

  before_action :authenticate_user!
  before_action :set_ticket, only: %i[show edit update destroy update_status]
  helper_method :tickets_view, :ticket_filters, :my_assignee, :resolution_streak_count, :resolution_streak_date

  def index
    update_session_from_params
    @tickets = Ticket.order(created_at: :desc)
    apply_filters
    set_wip_status
    set_wip_flash
    apply_view_scope
  end

  def show
  end

  def new
    @ticket = Ticket.new
  end

  def edit
  end

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save 
      redirect_to @ticket, notice: "Ticket was successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    previous_status = @ticket.status
    if @ticket.update(ticket_params)
      update_resolution_streak(previous_status, @ticket.status)
      redirect_to @ticket, notice: "Ticket was successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    previous_status = @ticket.status
    if @ticket.update(status_params)
      update_resolution_streak(previous_status, @ticket.status)
      respond_to do |format|
        format.html do
          redirect_to tickets_path(status_redirect_params), notice: "Ticket status updated."
        end
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to tickets_path, alert: "Could not update status." }
        format.json { render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @ticket.destroy
    redirect_to tickets_url, notice: "Ticket was successfully deleted."
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :status, :priority, :reporter, :assignee)
  end

  def status_params
    params.require(:ticket).permit(:status)
  end

  def tickets_view
    session[:tickets_view].presence || "list"
  end

  def ticket_filters
    session[:ticket_filters] || {}
  end

  def my_assignee
    session[:my_assignee]
  end

  def sanitize_filters(filters)
    filters.to_unsafe_h.slice(*FILTER_KEYS)
      .transform_values { |value| value.to_s.strip.presence }
      .compact
  end

  def apply_filters
    filters = ticket_filters
    return if filters.blank?

    if (query = filters["q"])
      query = "%#{ActiveRecord::Base.sanitize_sql_like(query.downcase)}%"
      @tickets = @tickets.where("LOWER(title) LIKE ? OR LOWER(description) LIKE ?", query, query)
    end
    apply_ci_filter("status", filters["status"])
    apply_ci_filter("priority", filters["priority"])
    apply_ci_filter("assignee", filters["assignee"])
  end

  def apply_ci_filter(column, value)
    return if value.blank?

    @tickets = @tickets.where("LOWER(#{column}) = ?", value.downcase)
  end

  def set_wip_status
    @wip_limit = WIP_LIMIT
    scope = Ticket.all
    if my_assignee.present?
      scope = scope.where("LOWER(assignee) = ?", my_assignee.downcase)
    end
    @wip_count = scope.where("LOWER(status) = ?", "wip").count
  end

  def resolution_streak_count
    session[:resolution_streak_count].to_i
  end

  def resolution_streak_date
    session[:resolution_streak_date]
  end

  def update_resolution_streak(previous_status, current_status)
    return unless resolved_transition?(previous_status, current_status)

    today = Date.current
    last_date = parse_streak_date(session[:resolution_streak_date])
    streak = session[:resolution_streak_count].to_i

    if last_date == today
      # already counted today
    elsif last_date == today - 1
      streak += 1
    else
      streak = 1
    end

    session[:resolution_streak_date] = today.to_s
    session[:resolution_streak_count] = streak
  end

  def resolved_transition?(previous_status, current_status)
    previous_status.to_s.downcase != "resolved" && current_status.to_s.downcase == "resolved"
  end

  def parse_streak_date(value)
    Date.parse(value.to_s)
  rescue ArgumentError, TypeError
    nil
  end

  def update_session_from_params
    session[:tickets_view] = params[:view] if %w[list board].include?(params[:view])
    session[:my_assignee] = params[:me] if params[:me].present?
    if params[:clear].present?
      session[:ticket_filters] = {}
    elsif params[:filters].present?
      session[:ticket_filters] = sanitize_filters(params[:filters])
    end
  end

  def apply_view_scope
    if tickets_view == "board"
      @board_limit = params[:limit].to_i
      @board_limit = BOARD_LIMIT_DEFAULT if @board_limit < 1
      @board_total = @tickets.count
      @tickets = @tickets.limit(@board_limit)
      @board_has_more = @board_total > @board_limit
    else
      @pagy, @tickets = pagy(:offset, @tickets, limit: LIST_LIMIT)
    end
  end

  def status_redirect_params
    {
      view: tickets_view,
      highlight: @ticket.id,
      page: params[:page],
      filters: ticket_filters
    }
  end

  def set_wip_flash
    return unless turbo_frame_request?

    flash.now[:alert] = nil
    flash.now[:notice] = nil
    if @wip_count > @wip_limit
      flash.now[:alert] = "You are over your WIP limit. Consider closing or reassigning a ticket to stay focused."
    elsif @wip_count.zero?
      flash.now[:notice] = "WIP is clear. Nice work keeping the board clean."
    end
  end
end
