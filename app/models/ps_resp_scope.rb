class PsRespScope < ActiveRecord::Base
  establish_connection :peoplesoft
  set_table_name "SYSADM.PSXLATITEM"
  
  def self.translate_resp_scope(ps_scope)
    scope = PsRespScope.find_by_fieldvalue(ps_scope)
    result = ps_scope
    if scope
      result = scope.xlatlongname
    end
    result
  end
end