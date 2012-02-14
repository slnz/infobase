class PsDeptTbl < ActiveRecord::Base
  establish_connection :peoplesoft
  set_table_name "SYSADM.PS_DEPT_TBL"
  
  def self.translate_ministry(ps_ministry)
    ministry = PsDeptTbl.find_by_deptid(ps_ministry)
    result = ps_ministry
    if ps_ministry == "CM"
      result = "Campus Ministry" # Override what's in PS - "The Campus Ministry"
    elsif ministry
      result = ministry.descr
    end
    result
  end
end