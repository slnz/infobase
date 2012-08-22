class FixUserInstantiation < ActiveRecord::Migration
  def up
    change_column :infobase_users, :type, :string, :default => "InfobaseUser"
  end

  def down
    change_column :infobase_users, :type, :string, :default => "InfobaseAdminUser"
  end
end
