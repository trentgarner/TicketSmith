# TicketSmith

TicketSmith is a lightweight ticket tracker built with Ruby on Rails. It focuses on fast status updates, an engaging board view, and simple UX nudges that help teams keep work moving.

## Features

- Ticket CRUD with status and priority
- List and board (swimlane) views with drag-and-drop
- Quick status updates from the list view
- Filters and "My Tickets" mode
- WIP limit indicator and resolution streak
- Automatic reminder flashes when WIP is too high or empty
- Pagination for list view and "Show next" for board
- Auth with Devise + guest login

## Stack

- Rails 7.2
- Turbo + Stimulus (Hotwire)
- SQLite (dev)
- Bootstrap 5 (CDN)
- Devise
- Pagy

## Getting Started

```bash
bundle install
bin/rails db:setup
bin/rails server
```

Visit `http://localhost:3000` and sign in or use "Continue as guest".

## Tests

```bash
bundle exec rspec
```

## Roadmap

- Per-user preferences (WIP limit, reminders)
- Admin role + team settings
- Ticket comments and activity log
- Notifications (email/Slack)
- Audit log and analytics
