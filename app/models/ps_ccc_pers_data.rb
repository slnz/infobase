class PsCccPersData < ActiveRecord::Base
  establish_connection :peoplesoft
  self.table_name = "SYSADM.PS_CCC_PERS_DATA"
end