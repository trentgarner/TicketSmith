class TicketsController < ApplicationController
  FILTER_KEYS = %w[q status priority assignee].freeze

  before_action :authenticate_user!
  before_action :set_ticket, only: %i[show edit update destroy update_status]
  helper_method :tickets_view, :ticket_filters, :my_assignee

  def index
    if %w[list board].include?(params[:view])
      session[:tickets_view] = params[:view]
    end
    if params[:me].present?
      session[:my_assignee] = params[:me]
    end
    if params[:clear].present?
      session[:ticket_filters] = {}
    elsif params[:filters].present?
      session[:ticket_filters] = sanitize_filters(params[:filters])
    end

    @tickets = Ticket.order(created_at: :desc)
    apply_filters
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
    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: "Ticket was successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end

  end

  def update_status
    if @ticket.update(status_params)
      respond_to do |format|
        format.html { redirect_to tickets_path, notice: "Ticket status updated." }
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
end
