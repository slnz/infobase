class Ccc::CrumpdUser < ActiveRecord::Base
  establish_connection :crumpd

  def merge(other)
    Ccc::CrumpdUser.transaction do
      Ccc::CrumpdReport.where(updated_by: other.id).update_all(updated_by: id)
      Ccc::CrumpdGroupCoach.where(user_id: other.id).update_all(user_id: id)
      Ccc::CrumpdTeamLeader.where(user_id: other.id).update_all(user_id: id)
      Ccc::CrumpdPeriodAdmin.where(user_id: other.id).update_all(user_id: id)

      self.is_admin = true if other.is_admin
      self.real_id = nil
      save


      # Delete the losing record
      begin
        other.reload
        other.destroy
      rescue ActiveRecord::RecordNotFound; end
    end
  end


end