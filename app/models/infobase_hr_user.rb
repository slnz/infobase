class InfobaseHrUser < InfobaseUser
  def can_add_contacts?() true; end
  def can_delete_contacts?() true; end
  def can_create_locations?() true; end
  def can_create_teams?() true; end
  def can_add_team_members?() true; end
  def can_remove_team_members?() true; end
  def can_add_team_leaders?() false; end
end
