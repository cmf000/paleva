module ApplicationHelper
  def format_time_range(opening_time, closing_time)
    "#{opening_time.strftime('%H:%M')} às #{closing_time.strftime('%H:%M')}"
  end
  def format_time_history(effective_at); end
end
