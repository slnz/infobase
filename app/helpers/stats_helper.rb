module StatsHelper
  # Returns if this day is in the first week of the month
  def first_week(date)
    (1..7).include?(date.day)
  end
  
  def unique_name(stat)
    result = "stat"
    if !stat.kind_of?(Hash) && stat.activity
      result = stat.activity.ActivityID.to_s + stat.peopleGroup.to_s
    end
    result
  end
end
