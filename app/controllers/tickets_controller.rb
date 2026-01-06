class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show edit update destroy]

  def index
    @tickets = Ticket.order(created_at: :desc)
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
end
