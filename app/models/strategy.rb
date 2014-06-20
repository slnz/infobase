class Strategy < ActiveRecord::Base
  default_scope { order('position, name')}

  def self.table_name
    'ministry_strategy'
  end
end