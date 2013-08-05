class BridgesPeopleGroupCondensing < ActiveRecord::Migration
  def up
    execute("create table ministry_statistic_before_pg_merge like ministry_statistic;")
    execute("insert ministry_statistic_before_pg_merge select * from ministry_statistic;")

    migrations = Statistic.where("peopleGroup is not null AND peopleGroup != ''")
    migrations.each do |stat|
      s = Statistic.where("fk_Activity = #{stat.fk_Activity}").where("periodBegin = '#{stat.periodBegin}'").where("peopleGroup is null OR peopleGroup = ''").first
      unless s
        s = Statistic.new
        s.fk_Activity = stat.fk_Activity
        s.periodBegin = stat.periodBegin
        s.periodEnd = stat.periodEnd
      end

      s.evangelisticOneOnOne = s.evangelisticOneOnOne.to_i + stat.evangelisticOneOnOne.to_i
      s.decisionsHelpedByOneOnOne = s.decisionsHelpedByOneOnOne.to_i + stat.decisionsHelpedByOneOnOne.to_i
      s.evangelisticGroup = s.evangelisticGroup.to_i + stat.evangelisticGroup.to_i
      s.decisionsHelpedByGroup = s.decisionsHelpedByGroup.to_i + stat.decisionsHelpedByGroup.to_i
      s.exposuresViaMedia = s.exposuresViaMedia.to_i + stat.exposuresViaMedia.to_i
      s.decisionsHelpedByMedia = s.decisionsHelpedByMedia.to_i + stat.decisionsHelpedByMedia.to_i
      s.spiritual_conversations = s.spiritual_conversations.to_i + stat.spiritual_conversations.to_i
      s.holySpiritConversations = s.holySpiritConversations.to_i + stat.holySpiritConversations.to_i
      s.laborersSent = s.laborersSent.to_i + stat.laborersSent.to_i
      s.faculty_sent = s.faculty_sent.to_i + stat.faculty_sent.to_i
      s.invldStudents = s.invldStudents.to_i + stat.invldStudents.to_i
      s.multipliers = s.multipliers.to_i + stat.multipliers.to_i
      s.studentLeaders = s.studentLeaders.to_i + stat.studentLeaders.to_i
      s.faculty_involved = s.faculty_involved.to_i + stat.faculty_involved.to_i
      s.faculty_engaged = s.faculty_engaged.to_i + stat.faculty_engaged.to_i
      s.faculty_leaders = s.faculty_leaders.to_i + stat.faculty_leaders.to_i

      s.save!
      stat.destroy
    end
  end

  def down
    drop_table :ministry_statistic
    execute("create table ministry_statistic like ministry_statistic_before_pg_merge;")
    execute("insert ministry_statistic select * from ministry_statistic_before_pg_merge;")
    drop_table :ministry_statistic_before_pg_merge
  end
end
