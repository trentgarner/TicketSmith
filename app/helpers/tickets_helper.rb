module TicketsHelper
  def status_badge_class(status)
    normalized = status.to_s.downcase.tr(" ", "_")
    case normalized
    when "open" then "secondary"
    when "in_progress", "wip" then "warning"
    when "resolved" then "success"
    else "secondary"
    end
  end

  def status_flash_class(status)
    "ticket-row--pulse-#{status_badge_class(status)}"
  end

  def status_display(status)
    status.to_s.tr("_", " ")
  end

  def priority_badge_class(priority)
    normalized = priority.to_s.downcase.tr(" ", "_")
    case normalized
    when "high" then "danger"
    when "medium" then "warning"
    when "low" then "info"
    else "secondary"
    end
  end
end
