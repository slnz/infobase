class Ccc::PersonAccess < ActiveRecord::Base

  self.table_name = 'person_accesses'

  def merge(other)
    self.national_access = other.national_access if other.national_access == 1
    self.regional_access = other.regional_access if other.regional_access == 1
    self.ics_access = other.ics_access if other.ics_access == 1
    self.intern_access = other.intern_access if other.intern_access == 1
    self.stint_access = other.stint_access if other.stint_access == 1
    self.mtl_access = other.mtl_access if other.mtl_access == 1
    self.individual_access = other.individual_access if other.individual_access == 1
    self.grant_individual_access = other.grant_individual_access if other.grant_individual_access == 1

    self.save
  end

end
