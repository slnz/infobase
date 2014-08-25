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

    if @filters[:lane]
      filtered_teams = filtered_teams.where("#{Team.table_name}.lane = ?", @filters[:lane])
    end

    if @filters[:target_area_id]
      filtered_teams = filtered_teams.joins(:activities).where("#{Activity.table_name}.fk_targetAreaID IN(?)", @filters[:target_area_id].split(','))
    end

    if @filters[:target_area_name]
      filtered_teams = filtered_teams.joins(:target_areas).where("#{TargetArea.table_name}.name IN(?)", @filters[:target_area_name].split('+'))
    end

    filtered_teams
  end
end