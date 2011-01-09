class CreateInfobaseAdminUsers < ActiveRecord::Migration
  def self.up
    create_table :infobase_users do |t|
      t.integer :user_id
      t.string :type, :default => 'InfobaseAdminUser'
      t.integer :created_by
      t.timestamps
    end
  end

  def self.down
    drop_table :infobase_users
  end
end
