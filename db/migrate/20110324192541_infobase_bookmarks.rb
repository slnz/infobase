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
  end

  def self.down
    drop_table :infobase_bookmarks
  end
end
