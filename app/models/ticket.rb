class Ticket < ApplicationRecord
  STATUSES = %w[open in_progress resolved].freeze
  PRIORITIES = %w[low medium high].freeze
  validates :title, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }, allow_blank: true
end
