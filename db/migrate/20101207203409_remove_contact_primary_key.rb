class RemoveContactPrimaryKey < ActiveRecord::Migration
  def self.up
    remove_column :ministry_movement_contact, :id
  end

  def self.down
    add_column :ministry_movement_contact, :id
  end
end
