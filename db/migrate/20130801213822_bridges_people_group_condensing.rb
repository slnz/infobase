class BridgesPeopleGroupCondensing < ActiveRecord::Migration
  def up
    execute("select * into ministry_statistic_before_pg_merge from ministry_statistic;")
  end

  def down
    drop_table :ministry_statistic
    execute("select * into ministry_statistic from ministry_statistic_before_pg_merge;")
    drop_table :ministry_statistic_before_pg_merge
  end
end
