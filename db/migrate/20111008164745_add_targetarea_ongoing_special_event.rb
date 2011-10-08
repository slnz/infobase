class AddTargetareaOngoingSpecialEvent < ActiveRecord::Migration
  def change
    add_column :ministry_targetarea, :ongoing_special_event, :boolean, :default => false
  end
end
