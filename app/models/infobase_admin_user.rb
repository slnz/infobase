class InfobaseAdminUser < InfobaseUser
  def can_add_contacts?() true; end
  def can_delete_contacts?() true; end
  def can_create_locations?() true; end
  def can_create_teams?() true; end
end
