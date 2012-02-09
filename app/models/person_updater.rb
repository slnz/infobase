class PersonUpdater
  def self.update_people_from_ps
    pu = PersonUpdater.new # Even though this could be a fully static class, I think it's more readable to deal with variables within an instance
    pu.update_people
  end
  
  def update_people
    update_staff_records
#    update_person_records
  end
  
  private
  
  def update_staff_records
    insert_and_remove_staff_records
#    update_staff_record_attributes
  end
  
  def insert_and_remove_staff_records
    staff = Staff.select("accountNo").where("removedFromPeopleSoft = 'N'").all.collect(&:accountNo)
    pstaff = PsEmployee.select("emplid, first_name, last_name").order("emplid")
    pstaff.each do |p_record|
      s_record = Staff.find_by_accountNo(p_record.emplid)
      if s_record # This record exists already
        # Check to make sure it's the right person
        if s_record.lastName.upcase == p_record.last_name.upcase && s_record.firstName.upcase == p_record.first_name.upcase
          staff.delete(p_record.emplid)
          Rails.logger.info("Record #{p_record.emplid} exists (#{p_record.first_name.to_s + " " + p_record.last_name.to_s}).")
        else # Name doesn't match
          maiden = PsCccPersData.where("emplid = ?", p_record.emplid).first
          if maiden && !maiden.maiden_emplid.blank? # Changed emplid at some point
            maiden_record = Staff.find_by_accountNo(maiden.maiden_emplid)
            # Check maiden record for name accuracy
            if maiden_record && maiden_record.lastName.upcase == p_record.last_name.upcase && maiden_record.firstName.upcase == p_record.first_name.upcase
              # Name is correct in maiden_record
              s_record.update_attribute(:accountNo, s_record.accountNo + "_old")
              s_record.removedFromPeopleSoft = "Y"
              s_record.person_id = nil
              s_record.save!
              switch_account_number(maiden_record, p_record.emplid)
              staff.delete(p_record.emplid)
              Rails.logger.info("Record #{p_record.emplid} existed (#{p_record.first_name.to_s + " " + p_record.last_name.to_s}), but name didn't match (#{s_record.firstName.to_s + " " + s_record.lastName.to_s}).  Found maiden record #{maiden.maiden_emplid} and switched account numbers.")
            elsif maiden_record
              # Name is incorrect in maiden_record, will switch anyway
              s_record.update_attribute(:accountNo, s_record.accountNo + "_old")
              s_record.removedFromPeopleSoft = "Y"
              s_record.person_id = nil
              s_record.save!
              switch_account_number(maiden_record, p_record.emplid)
              staff.delete(p_record.emplid)
              Rails.logger.info("Record #{p_record.emplid} existed (#{p_record.first_name.to_s + " " + p_record.last_name.to_s}), but name didn't match (#{s_record.firstName.to_s + " " + s_record.lastName.to_s}).  Found maiden record #{maiden.maiden_emplid} but name still didn't match (#{maiden_record.firstName.to_s + " " + maiden_record.lastName.to_s}).  Switched account numbers anyway.")
            else
              # Maiden record not found in our database, leave as is.
              staff.delete(p_record.emplid)
              Rails.logger.info("Record #{p_record.emplid} exists (#{p_record.first_name.to_s + " " + p_record.last_name.to_s}), but name doesn't match (#{s_record.firstName.to_s + " " + s_record.lastName.to_s}).  Maiden record exists in PS, not in Staff table.  Leaving as is.")
            end
          else
            staff.delete(p_record.emplid)
            Rails.logger.info("Record #{p_record.emplid} exists (#{p_record.first_name.to_s + " " + p_record.last_name.to_s}), but name doesn't match (#{s_record.firstName.to_s + " " + s_record.lastName.to_s}).  No maiden record found.  Leaving as is.")
          end
        end
      else # record does not exist
        maiden = PsCccPersData.where("emplid = ?", p_record.emplid).first
        if maiden && !maiden.maiden_emplid.blank? # Changed emplid at some point
          s_record = Staff.find_by_accountNo(maiden.maiden_emplid)
          if s_record
            switch_account_number(s_record, maiden.emplid)
            staff.delete(maiden.maiden_emplid)
            Rails.logger.info("Record #{p_record.emplid} did not exist (#{p_record.first_name.to_s + " " + p_record.last_name.to_s}).  Found old record #{maiden.maiden_emplid} from maiden table and switched account numbers for staff record (#{s_record.firstName.to_s + " " + s_record.lastName.to_s}).")
          else
            s = Staff.new({:firstName => p_record.first_name, :lastName => p_record.last_name, :removedFromPeopleSoft => "N"})
            s.accountNo = p_record.emplid
            s.save!
            Rails.logger.info("Record #{p_record.emplid} did not exist (#{p_record.first_name.to_s + " " + p_record.last_name.to_s}).  Did not find a record from maiden table.  Created new record.")
          end
        else
          s = Staff.new({:firstName => p_record.first_name, :lastName => p_record.last_name, :removedFromPeopleSoft => "N"})
          s.accountNo = p_record.emplid
          s.save!
          Rails.logger.info("Record #{p_record.emplid} did not exist (#{p_record.first_name.to_s + " " + p_record.last_name.to_s}).  Did not find a record in maiden table.  Created new record.")
        end
      end
    end
    
    # Staff records not accounted for in PS, check and set removedFromPeopleSoft to "Y"
    staff.each do |account_no|
      s_record = Staff.find_by_accountNo(account_no)
      if s_record
        if PsEmployee.find_by_emplid(s_record.accountNo)
          Rails.logger.info("Record #{s_record.accountNo} is in PS but was never checked off.  Why????????????????????????")
        else
          s_record.removedFromPeopleSoft = "Y"
          s_record.save!
          Rails.logger.info("Record #{s_record.accountNo} removed from PS.")
        end
      end
    end
  end
  
  def switch_account_number(staff, account_no)
    new_record = staff.clone
    staff.removedFromPeopleSoft = "Y"
    staff.person_id = nil
    staff.save!
    new_record.accountNo = account_no
    new_record.removedFromPeopleSoft = "N"
    new_record.save!
  end
end