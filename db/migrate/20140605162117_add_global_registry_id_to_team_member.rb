class AddGlobalRegistryIdToTeamMember < ActiveRecord::Migration
  def change
    add_column :ministry_missional_team_member, :global_registry_id, :string
  end
end
