class InfobaseBookmarks < ActiveRecord::Migration
  class InfobaseBookmark < ActiveRecord::Base
  end
  
  def self.up
    create_table(:infobase_bookmarks) do |t|
      t.column :user_id, :int
      t.column :name, :string, :limit => 64
      t.column :value, :string
    end
    add_index :infobase_bookmarks, :user_id
    add_index :infobase_bookmarks, :name
    
    old_bookmarks = StaffsitePref.where("name IN ('LOCALLEVEL', 'STATISTIC', 'TARGETAREA')")
    old_bookmarks.each do |bookmark|
      profile = StaffsiteProfile.find_by_StaffSiteProfileID(bookmark.fk_StaffSiteProfile) if bookmark.fk_StaffSiteProfile
      user = User.find_by_username(profile.userName) if profile
      InfobaseBookmark.create(:user_id => user.userID, :name => bookmark.name, :value => bookmark.value) if user
    end
    
    execute "update infobase_bookmarks set name = 'activity' where name = 'STATISTIC'"
    execute "update infobase_bookmarks set name = 'team' where name = 'LOCALLEVEL'"
    execute "update infobase_bookmarks set name = 'target_area' where name = 'TARGETAREA'"
  end

  def self.down
    drop_table :infobase_bookmarks
  end
end
