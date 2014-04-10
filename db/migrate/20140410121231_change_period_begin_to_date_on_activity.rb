class ChangePeriodBeginToDateOnActivity < ActiveRecord::Migration
  def change
    change_column :ministry_activity, :periodBegin, :date
  end
end
