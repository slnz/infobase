class SsmNeedsMerge < ActiveRecord::Migration
  def up
    add_column :simplesecuritymanager_user, :needs_merge, :string
  end

  def down
    remove_column :simplesecuritymanager_user, :needs_merge
  end
end
