class InfobaseUser < ActiveRecord::Base
  belongs_to :user
  
  def can_add_contacts?() false; end 
  def can_delete_contacts?() false; end
  def can_create_locations?() false; end
  def can_create_teams?() false; end
  def can_add_team_members?() false; end
  def can_remove_team_members?() false; end
  def can_add_team_leaders?() false; end
  
  def self.determine_infobase_user(user, emplid)
    @info_user = nil
    @user = user
    @emplid

    if @user
      @info_user = find_by_user_id(user.id)
      unless @info_user
        
        @staff = user.person.staff

        # If they have staffsite access they're in
        # ssp = StaffsiteProfile.find_by_userName(user.username)
        # if ssp || emplid # If they're an employee, let them in
        #   info_user = new()
        # end
        auth_staff_site

        # # If they're HR or a "Director" they have admin access, only HR Directors can make Team Leaders
        # staff = user.person.staff
        # if info_user && staff && staff.is_hr_director?
        #   info_user = InfobaseAdminUser.new()
        # elsif info_user && staff && (staff.is_hr? || staff.is_director?)
        #   info_user = InfobaseHrUser.new()
        # end
        auth_hr

        # # access if person not removed from People Soft
        # if staff && info_user.nil?
        #   info_user = new() if staff.removedFromPeopleSoft == "N"
        # end
        auth_people_soft

        # access if person is on 1 or more team
        # if info_user.nil?
        #   info_user = new() if user.person.teams.count > 0
        # end
        auth_on_team
      end
    end
    @info_user
  end

  def self.auth_staff_site
    username = @user.username
    ssp = StaffsiteProfile.find_by_userName(username)
    if ssp || @emplid
      @info_user = InfobaseUser.new()
    end
  end

  def self.auth_hr
    if @info_user && @staff && @staff.is_hr_director?
      @info_user = InfobaseAdminUser.new()
    elsif @info_user && @staff && (@staff.is_hr? || @staff.is_director?)
      @info_user = InfobaseHrUser.new()
    end
  end

  def self.auth_people_soft
    if @staff && @info_user.nil?
      @info_user = new() if @staff.removedFromPeopleSoft == "N"
    end    
  end

  def self.auth_on_team
    if @info_user.nil?
      @info_user = InfobaseUser.new() if @user.person.teams.count > 0
    end
  end
end
