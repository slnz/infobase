class Ccc::SpUser < ActiveRecord::Base


  self.inheritance_column = 'fake'
  belongs_to :ministry_person, class_name: 'Person', foreign_key: :person_id
  belongs_to :simplesecuritymanager_user, class_name: 'Ccc::SimplesecuritymanagerUser', foreign_key: :ssm_id

  def merge(other)
		roles = %w{SpNationalCoordinator SpDonationServices SpRegionalCoordinator SpDirector SpEvaluator SpProjectStaff SpGeneralStaff}
		if other.type != nil && type != nil && roles.index(other.type) < roles.index(type)    #this last type is from self, but doesn't call it I guess - what is guideline of when to put self & when not to? - Ask Justin... #TODO
   		self.type = other.type                                                            #self.type is used here
		end	
    other.reload
   	other.destroy
		save                                                                          #save is called without using 'self' here...Ask Justin...
  end

end
