class InfobaseUser < ActiveRecord::Base
  belongs_to :user
  
  def self.determine_infobase_user(user)
    info_user = nil
    if user
      info_user = find_by_user_id(user.id)
      unless info_user
        # TODO: Hardcode how to determine if HR
      end
    end
    info_user
  end
end
