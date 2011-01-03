class RenameMinistryActivityHistory < ActiveRecord::Migration
  def self.up
    rename_column :ministry_activity_history, :from_status, :from_status_deprecated
    rename_column :ministry_activity_history, :to_status, :status
    rename_column :ministry_activity_history, :period_end, :period_end_deprecated
    remove_column :ministry_activity_history, :fromStrategy
    remove_column :ministry_activity_history, :toStrategy
  end

  def self.down
    rename_column :ministry_activity_history, :from_status_deprecated, :from_status
    rename_column :ministry_activity_history, :status, :to_status
    rename_column :ministry_activity_history, :period_end_deprecated, :period_end
    add_column :ministry_activity_history, :fromStrategy, :string
    add_column :ministry_activity_history, :toStrategy, :string
  end
end
