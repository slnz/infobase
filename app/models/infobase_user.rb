class InfobaseUser < ActiveRecord::Base
  belongs_to :user
  
  def can_add_contacts?() false; end 
  def can_delete_contacts?() false; end
  def can_create_locations?() false; end
  def can_create_teams?() false; end
  
  def self.determine_infobase_user(user, emplid)
    info_user = nil
    if user
      info_user = find_by_user_id(user.id)
      unless info_user
        # If they have staffsite access they're in
        ssp = StaffsiteProfile.find_by_userName(user.username)
        if ssp || emplid # If they're an employee, let them in
          info_user = new()
        end
        
        # If they're HR or a "Director" they have admin access
        staff = user.person.staff
        if info_user && staff && (staff.is_hr? || staff.is_director?)
          info_user = InfobaseAdminUser.new()
        end
      end
    end
    info_user
  end
end
