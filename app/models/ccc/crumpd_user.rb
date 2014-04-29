class CrumpdUser < ActiveRecord::Base
  establish_connection :crumpd

  has_many :assignments
  has_many :group_coaches
  has_many :team_leaders
  has_many :period_admins

  def merge(other)
    other.update_attributes(real_id: id)
    # CrumpdUser.transaction do
    #   other.assignments.each { |ua| ua.update_attribute(:user_id, id) }
    #   other.group_coaches.each { |ua| ua.update_attribute(:user_id, id) }
    #   other.team_leaders.each { |ua| ua.update_attribute(:user_id, id) }
    #   other.period_admins.each { |ua| ua.update_attribute(:user_id, id) }
    #
    #   save
    # end
    #
    # reload
    # merge_assignments(other)
    #
    # # Delete the losing record
    # begin
    #   other.reload
    #   other.destroy
    # rescue ActiveRecord::RecordNotFound; end
  end

  # def merge_assignments(other)
  #   merged_assignments = []
  #
  #   assignments.reload.each do |assignment|
  #     next if merged_assignments.include?(assignment)
  #
  #     other_assignment = other.assignments.detect { |a| a.period_id == assignment.period_id }
  #     if other_assignment
  #       assignment.merge(other_assignment)
  #       merged_assignments << assignment
  #     end
  #   end
  # end
end