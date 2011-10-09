class MigrateBookmarks < ActiveRecord::Migration
  def self.up
    old_bookmarks = StaffsitePref.where("name IN ('LOCALLEVEL', 'STATISTIC', 'TARGETAREA', 'CURRENT_BALANCE')")
    old_bookmarks.each do |bookmark|
      profile = StaffsiteProfile.find_by_StaffSiteProfileID(bookmark.fk_StaffSiteProfile) if bookmark.fk_StaffSiteProfile
      user = User.find_by_username(profile.userName) if profile
      Bookmark.create(:user_id => user.userID, :name => bookmark.name, :value => bookmark.value) if user
    end
    
    execute "update infobase_bookmarks set name = 'activity' where name = 'STATISTIC'"
    execute "update infobase_bookmarks set name = 'team' where name = 'LOCALLEVEL'"
    execute "update infobase_bookmarks set name = 'target_area' where name = 'TARGETAREA'"
    execute "update infobase_bookmarks set name = 'balance' where name = 'CURRENT_BALANCE'"
  end

  def self.down
  end
end
