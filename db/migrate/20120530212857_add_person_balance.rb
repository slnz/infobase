class AddPersonBalance < ActiveRecord::Migration
  def up
    add_column :ministry_person, :balance_daily, :decimal, :precision => 10, :scale => 2
  end

  def down
    remove_column :ministry_person, :balance_daily
  end
end
