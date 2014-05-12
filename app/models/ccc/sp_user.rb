class Ccc::SpUser < ActiveRecord::Base


  self.inheritance_column = 'fake'
  belongs_to :ministry_person, class_name: 'Person', foreign_key: :person_id
  belongs_to :simplesecuritymanager_user, class_name: 'Ccc::SimplesecuritymanagerUser', foreign_key: :ssm_id

  def merge(other)
		roles = %w{SpNationalCoordinator SpDonationServices SpRegionalCoordinator SpDirector SpEvaluator SpProjectStaff SpGeneralStaff}
		if other.type != nil && type != nil && roles.index(other.type) < roles.index(type)    # this last '(type)' call refers to self
   		self.type = other.type                                                    # self.type is used explicitly here
		end	
    other.reload
   	other.destroy
		save                                                                  # this call to 'save' refers to self
  end

end
