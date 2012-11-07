class AddTimestamps < ActiveRecord::Migration
  def change
    add_column :ministry_activity, :created_at, :datetime
    add_column :ministry_activity, :updated_at, :datetime
    add_column :ministry_activity_history, :created_at, :datetime
    add_column :ministry_activity_history, :updated_at, :datetime
    add_column :ministry_locallevel, :created_at, :datetime
    add_column :ministry_locallevel, :updated_at, :datetime
    add_column :ministry_missional_team_member, :created_at, :datetime
    add_column :ministry_missional_team_member, :updated_at, :datetime
    add_column :ministry_movement_contact, :created_at, :datetime
    add_column :ministry_movement_contact, :updated_at, :datetime
    add_column :ministry_statistic, :created_at, :datetime
    add_column :ministry_targetarea, :created_at, :datetime
    add_column :ministry_targetarea, :updated_at, :datetime
  end
end
