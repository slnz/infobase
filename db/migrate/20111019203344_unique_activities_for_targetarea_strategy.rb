class UniqueActivitiesForTargetareaStrategy < ActiveRecord::Migration
  def change
    add_index :ministry_activity, [:fk_targetareaid, :strategy], :unique => true
  end
end
