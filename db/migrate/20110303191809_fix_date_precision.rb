class FixDatePrecision < ActiveRecord::Migration
  def self.up
    change_column :ministry_statistic, :periodBegin, :date
    change_column :ministry_statistic, :periodEnd, :date
  end

  def self.down
    change_column :ministry_statistic, :periodBegin, :datetime
    change_column :ministry_statistic, :periodEnd, :datetime
  end
end
