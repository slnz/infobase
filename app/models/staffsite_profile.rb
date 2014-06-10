class StaffsiteProfile < ActiveRecord::Base
  self.table_name = "staffsite_staffsiteprofile"
  self.primary_key = "StaffSiteProfileID"

  def full_name
    first_name.to_s  + " " + last_name.to_s
  end

  # an alias for firstName using standard ruby/rails conventions
  def first_name
    firstName
  end

  # an alias for lastName using standard ruby/rails conventions
  def last_name
    lastName
  end
end
