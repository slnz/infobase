class AddGateToTargetArea < ActiveRecord::Migration
  def change
    add_column :ministry_targetarea, :gate, :string
  end
end
