module Qe
  # prefix for database tables
  mattr_accessor :table_name_prefix
  self.table_name_prefix = 'info_'

  mattr_accessor :answer_sheet_class
  self.answer_sheet_class = 'Infobase'

  mattr_accessor :from_email
  self.from_email = 'Infobase Help <help@cru.org>'

end