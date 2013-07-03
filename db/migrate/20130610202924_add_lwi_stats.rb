class AddLwiStats < ActiveRecord::Migration
  def up
    add_column :ministry_statistic, :spiritual_conversations, :integer
    add_column :ministry_statistic, :faculty_sent, :integer
    add_column :ministry_statistic, :faculty_involved, :integer
    add_column :ministry_statistic, :faculty_engaged, :integer
    add_column :ministry_statistic, :faculty_leaders, :integer
  end

  def down
    remove_column :ministry_statistic, :spiritual_conversations    
    remove_column :ministry_statistic, :faculty_engaged    
    remove_column :ministry_statistic, :faculty_involved    
    remove_column :ministry_statistic, :faculty_leaders    
    remove_column :ministry_statistic, :faculty_sent    
  end
end
