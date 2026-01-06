class Ticket < ApplicationRecord
  STATUSES = %w[Open WIP Resolved].freeze
  PRIORITIES = %w[Low Medium High].freeze
  validates :title, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }
end
