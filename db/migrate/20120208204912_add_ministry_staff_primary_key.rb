class AddMinistryStaffPrimaryKey < ActiveRecord::Migration
  def up
    change_column :ministry_staff, :accountNo, :string, :limit => 15
  end

  def down
  end
end
