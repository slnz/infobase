class AddStatisticSpYear < ActiveRecord::Migration
  def up
    add_column :ministry_statistic, :sp_year, :int
  end

  def down
    remove_column :ministry_statistic, :sp_year
  end
end
