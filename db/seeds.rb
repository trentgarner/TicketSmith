# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Ticket.destroy_all

seed_tickets = [
  { title: "Payment outage", description: "Stripe callback failing", status: "Open", priority: "High", reporter: "Support Bot", assignee: "Steph" },
  { title: "UI typo", description: "Dashboard shows 'Suport'", status: "WIP", priority: "Low", reporter: "QA", assignee: "Trent" },
  { title: "Add 2FA", description: "Security requested TOTP support", status: "Resolved", priority: "Medium", reporter: "Product team", assignee: "Ruby" }
]

seed_tickets.each { |attrs| Ticket.create!(attrs) }

if Rails.env.development?
  require "faker"
  assignees = ["Trent", "Steph", "Ruby", "Sam", "Avery", "Jordan"]
  reporters = ["Support Bot", "QA", "Product team", "On-call", "Customer Success"]

  100.times do
    Ticket.create!(
      title: Faker::Hacker.say_something_smart,
      description: Faker::Lorem.paragraph(sentence_count: 4),
      status: Ticket::STATUSES.sample,
      priority: Ticket::PRIORITIES.sample,
      reporter: reporters.sample,
      assignee: assignees.sample
    )
  end
end
