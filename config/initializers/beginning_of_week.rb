# TODO: Pretty sure this needs to go in common_engine...
require 'active_support/duration'
require 'active_support/core_ext/date/acts_like'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/date_time/conversions'
require 'active_support/core_ext/time/acts_like'
require 'active_support/core_ext/time/calculations'

class Time
  def traditional_beginning_of_week
    (self - self.wday.days).to_date
  end
  def traditional_end_of_week
    (self + (6.days - self.wday.days)).to_date
  end
end

class Date
  def traditional_beginning_of_week
    (self - self.wday.days).to_date
  end
  def traditional_end_of_week
    (self + (6.days - self.wday.days)).to_date
  end
end
