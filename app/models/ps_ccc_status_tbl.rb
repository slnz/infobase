class PsCccStatusTbl < ActiveRecord::Base
  establish_connection :peoplesoft
  set_table_name "SYSADM.PS_CCC_STATUS_TBL"
  
  def self.translate_status(ps_status)
    status = PsCccStatusTbl.find_by_status_code(ps_status)
    result = ps_status
    if status
      result = status.descr
    end
    result
  end
end