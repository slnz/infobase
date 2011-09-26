class AddYearsToSpStats < ActiveRecord::Migration
  def change
    t_areas = TargetArea.where("eventType = 'SP'")
    t_areas.each do |ta|
      activities = ta.all_activities
      if activities.size > 1
        raise "Too many activities for #{ta.targetAreaID}"
      else
        activity = activities.first
        stats = activity.statistics
        stats.each do |stat|
          year = stat.periodBegin.year
          stat.sp_year = year
          stat.save!
        end
      end
    end
  end
end
