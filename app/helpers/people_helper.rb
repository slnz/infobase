module PeopleHelper
  def display_strategy(strategy)
    result = Staff.strategies[strategy]
    result ||= strategy
  end
end
