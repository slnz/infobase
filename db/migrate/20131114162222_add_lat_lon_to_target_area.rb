class AddLatLonToTargetArea < ActiveRecord::Migration
  def change
    add_column :ministry_targetarea, :latitude, :decimal, precision: 11, scale: 7
    add_column :ministry_targetarea, :longitude, :decimal, precision: 11, scale: 7
  end
end
