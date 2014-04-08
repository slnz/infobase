class AddGlobalRegistryIdToMinistry < ActiveRecord::Migration
  def change
    add_column :ministries, :global_registry_id, :bigint
    add_column :ministry_regionalteam, :global_registry_id, :bigint
  end
end
