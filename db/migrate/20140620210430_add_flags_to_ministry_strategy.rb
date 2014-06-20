class AddFlagsToMinistryStrategy < ActiveRecord::Migration
  def change
    add_column :ministry_strategy, :event, :boolean, null: false, defaul: false
    add_column :ministry_strategy, :city, :boolean, null: false, defaul: false
  end
end
