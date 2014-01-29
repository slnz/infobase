class PersonAccess < ActiveRecord::Base

  def any_access_set
    national_access? || regional_access? || ics_access? || intern_access? || stint_access? ||
        mtl_access? || individual_access? || grant_individual_access?
  end

  def jobstatus_access
    if stint_access? && intern_access?
      'stint_and_intern'
    elsif stint_access?
      'stint'
    elsif intern_access?
      'intern'
    elsif ics_access?
      'ics'
    else
      ''
    end
  end

  def jobtitle_access
    mtl_access? ? 'mtl' : ''
  end
end
