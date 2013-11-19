class TeamFilter
  attr_accessor :teams, :filters

  def initialize(filters)
    @filters = filters || {}

    # strip extra spaces from filters
    @filters.collect { |k, v| @filters[k] = v.to_s.strip }
  end

  def filter(teams)
    filtered_teams = teams

    if @filters[:name]
      filtered_teams = filtered_teams.where("#{Team.table_name}.name like ?", "%#{@filters[:name]}%")
    end

    filtered_teams
  end
end