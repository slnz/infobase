class CrumpdAssignment < ActiveRecord::Base
  establish_connection :crumpd

  has_many :pledges
  has_many :reports
  has_many :goals

  # def merge(other)
  #   CrumpdUser.transaction do
  #     other.pledges.each { |ua| ua.update_attribute(:assignment_id, id) }
  #     other.reports.each { |ua| ua.update_attribute(:assignment_id, id) }
  #     other.goals.each { |ua| ua.update_attribute(:assignment_id, id) }
  #
  #     # keep the higher status
  #     if statuses.index_of(other.status) > statuses.index_of(status)
  #       self.status = other.status
  #     end
  #
  #     save
  #   end
  #
  #   reload
  #   merge_goals(other)
  #
  #   # Delete the losing record
  #   begin
  #     other.reload
  #     other.destroy
  #   rescue ActiveRecord::RecordNotFound; end
  # end

  # def merge_goals(other)
  #   merged_goals = []
  #
  #   goals.reload.each do |goal|
  #     next if merged_goals.include?(goal)
  #
  #     other_goal = other.goals.detect { |g| g.frequency == goal.frequency }
  #     if other_goal
  #       goal.update_attribute(:amount, other_goal.amount) if other_goal.amount > goal.amount
  #       merged_goals << goal
  #     end
  #   end
  #
  #   def statuses
  #     ['accepted','placed','on_assignment','alumni']
  #   end
  # end
end