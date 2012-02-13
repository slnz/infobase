class ChangeMinistryTargetareaNotesToBlob < ActiveRecord::Migration
  def up
    change_column :ministry_targetarea, :note, :text
  end

  def down
  end
end
