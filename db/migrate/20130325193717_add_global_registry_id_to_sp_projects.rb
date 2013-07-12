class AddGlobalRegistryIdToSpProjects < ActiveRecord::Migration
  def change
    add_column :sp_projects, :global_registry_id, :integer
    add_index :sp_projects, :global_registry_id
    add_column :hr_si_project, :global_registry_id, :integer
    add_index :hr_si_project, :global_registry_id
    add_column :ministry_locallevel, :global_registry_id, :integer
    add_index :ministry_locallevel, :global_registry_id
  end
end
