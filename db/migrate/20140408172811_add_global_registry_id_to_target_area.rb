class AddGlobalRegistryIdToTargetArea < ActiveRecord::Migration
  def change
    add_column :ministry_targetarea, :global_registry_id, :bigint
    add_column :ministry_activity, :global_registry_id, :bigint
  end
end
