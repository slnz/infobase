class AddLwiStats < ActiveRecord::Migration
  def up
    add_column :ministry_statistic, :spiritual_conversations, :integer
  end

  def down
    remove_column :ministry_statistic, :spiritual_conversations    
  end
end
