class Ccc::SimplesecuritymanagerUser < ActiveRecord::Base



  self.primary_key = 'userID'
  self.table_name = 'simplesecuritymanager_user'

  has_one :sp_user, class_name: 'Ccc::SpUser'
  has_one :mpd_user, class_name: 'Ccc::MpdUser', foreign_key: :user_id, dependent: :destroy
  has_one :infobase_user, foreign_key: :user_id, class_name: 'Ccc::InfobaseUser', dependent: :destroy
  has_one :si_user, foreign_key: :ssm_id, class_name: 'Ccc::SiUser', foreign_key: 'ssm_id'
  has_one :pr_user, foreign_key: :ssm_id, class_name: 'Ccc::PrUser', dependent: :destroy, foreign_key: 'ssm_id'
  has_many :authentications, class_name: 'Ccc::Authentication', foreign_key: 'user_id'
  has_one :person, class_name: 'Ccc::Person', foreign_key: 'fk_ssmUserId'

  def merge(other)
    User.connection.execute('SET foreign_key_checks = 0')

    User.transaction do
      
      if !other.globallyUniqueID.blank? && self.globallyUniqueID.blank?
        self.globallyUniqueID = other.globallyUniqueID
        other.globallyUniqueID = nil
      end

      person.merge(other.person) if person

      # Authentications
      other.authentications.collect {|oa| oa.update_attribute(:user_id, id)}

      if other.mpd_user && mpd_user
        mpd_user.merge(other.mpd_user)
      elsif other.mpd_user
        other.mpd_user.update_attribute(:user_id, userID)
      end

      if other.infobase_user && infobase_user
        infobase_user.merge(other.infobase_user)

      elsif other.infobase_user
        other.infobase_user.update_attribute(:user_id, userID)
      end

      if other.pr_user && pr_user
        other.pr_user.destroy
      elsif other.pr_user
        other.pr_user.update_attribute(:ssm_id, userID)
      end

      if other.si_user && si_user
        other.si_user.destroy
      elsif other.si_user
        SiUser.where(["ssm_id = ? or created_by_id = ?", other.userID, other.userID]).each do |ua|
          ua.update_attribute(:ssm_id, userID) if ua.ssm_id == other.userID
          ua.update_attribute(:created_by_id, personID) if ua.created_by_id == other.userID
        end
      end
      
      begin
        other.save(validate: false)
        save(validate: false)
      rescue ActiveRecord::ReadOnlyRecord

      end
    end

    MergeAudit.create!(mergeable: self, merge_looser: other)
    other.reload
    other.destroy

    User.connection.execute('SET foreign_key_checks = 1')

  end
end
