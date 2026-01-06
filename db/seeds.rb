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

tickets = [
  { title: "Payment outage", description: "Stripe callback failing", status: "open", priority: "high", reporter: "Support Bot", assignee: "Devon" },
  { title: "UI typo", description: "Dashboard shows 'Suport'", status: "in_progress", priority: "low", reporter: "QA", assignee: "Avery" },
  { title: "Add 2FA", description: "Security requested TOTP support", status: "resolved", priority: "medium", reporter: "Product", assignee: "Sam" }
]

tickets.each { |attrs| Ticket.create!(attrs) }
