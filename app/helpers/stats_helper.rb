module StatsHelper
  # Returns if this day is in the first week of the month
  def first_week(date)
    (1..7).include?(date.day)
  end
end
