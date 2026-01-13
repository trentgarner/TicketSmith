class User < ApplicationRecord
  DEFAULT_WIP_LIMIT = 3

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :wip_limit, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.hex(16)
      user.assignee_name = "Guest"
      user.wip_limit = DEFAULT_WIP_LIMIT
      user.reminders_enabled = true
    end
  end

  def wip_limit_value
    wip_limit.presence || DEFAULT_WIP_LIMIT
  end

  def reminders_enabled?
    reminders_enabled.nil? ? true : reminders_enabled
  end
end
