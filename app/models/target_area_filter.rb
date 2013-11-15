class TargetAreaFilter
  attr_accessor :target_areas, :filters

  def initialize(filters)
    @filters = filters || {}

    # strip extra spaces from filters
    @filters.collect { |k, v| @filters[k] = v.to_s.strip }
  end

  def filter(target_areas)
    filtered_target_areas = target_areas

    if @filters[:name]
      filtered_target_areas = filtered_target_areas.where("#{TargetArea.table_name}.name like ?", "%#{@filters[:name]}%")
    end

    filtered_target_areas
  end
end
