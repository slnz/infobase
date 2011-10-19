class FixActivityRecords < ActiveRecord::Migration
  def change
    acts = Activity.select(:fk_targetareaid).select(:strategy).group(:fk_targetareaid, :strategy).having("count(*) > 1")
    acts.each do |act|
      activities = Activity.where(:fk_targetareaid => act.fk_targetareaid).where(:strategy => act.strategy).order(:activityID)
      last_activity = activities.last
      activities.each do |activity|
        if activity.id != last_activity.id && activity.status != "IN"
          raise "Too many inactive strategies for #{activity.id}."
        end
        activity.activity_histories.each do |activity_history|
          activity_history.activity_id = last_activity.id
          activity_history.save!
        end
        activity.statistics.each do |statistic|
          statistic.fk_Activity = last_activity.id
          statistic.save!(:validate => false)
        end
        if activity.id != last_activity.id
          activity.destroy
          if !activity.destroyed?
            raise "Activity #{activity.id} not destroyed."
          end
        end
      end
      last_histories = last_activity.activity_histories.order(:period_begin)
      last_history = last_histories.last
      last_activity.periodBegin = last_history.period_begin
      last_activity.save!
    end
  end
end
