class PsTaxLocation < ActiveRecord::Base
  establish_connection :peoplesoft
  self.table_name = "SYSADM.PS_TAX_LOCATION1"
  self.primary_key = "tax_location_cd"
end