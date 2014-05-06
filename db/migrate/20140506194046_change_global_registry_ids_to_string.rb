class ChangeGlobalRegistryIdsToString < ActiveRecord::Migration
  def change
    [:hr_si_project, :ministries, :ministry_activity, :ministry_locallevel, :ministry_person, :ministry_regionalteam, :ministry_targetarea,
     :sp_applications, :sp_gospel_in_actions, :sp_ministry_focuses, :sp_project_gospel_in_actions, :sp_project_ministry_focuses,
     :sp_projects, :sp_staff, :sp_stats, :sp_student_quotes, :sp_users, :sp_world_regions, :ministry_person].each do |table|
      change_column table, :global_registry_id, :string
    end
  end
end
