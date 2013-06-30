class AddGlobalRegistryIdToMinistryPerson < ActiveRecord::Migration
  def change
    add_column :ministry_person, :global_registry_id, :integer
    add_index :ministry_person, :global_registry_id
  end
end
