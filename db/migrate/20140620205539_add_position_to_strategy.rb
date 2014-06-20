class AddPositionToStrategy < ActiveRecord::Migration
  def change
    add_column :ministry_strategy, :position, :integer, null: false, default: 0
  end
end
