class ActivityFilter
  attr_accessor :activities, :filters

  def initialize(filters)
    @filters = filters || {}

    # strip extra spaces from filters
    @filters.collect { |k, v| @filters[k] = v.to_s.strip }
  end

  def filter(activities)
    filtered_activities = activities

    if @filters[:status]
      filtered_activities = filtered_activities.where("#{Activity.table_name}.status IN(?)", @filters[:status]).split(',')
    else
      filtered_activities = filtered_activities.active
    end

    if @filters[:team_id]
      filtered_activities = filtered_activities.where("#{Activity.table_name}.fk_teamID IN(?)", @filters[:team_id].split(','))
    end
    
    if @filters[:strategy]
      filtered_activities = filtered_activities.where('strategy' => @filters[:strategy].split(','))
    end

    filtered_activities
  end
end
