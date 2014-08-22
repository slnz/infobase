class TargetAreaFilter
  attr_accessor :target_areas, :filters

  def initialize(filters)
    @filters = filters || {}

    # strip extra spaces from filters
    @filters.collect { |k, v| @filters[k] = v.to_s.strip }
  end

  def filter(target_areas)
    filtered_target_areas = target_areas

    if @filters[:type]
      filtered_target_areas = filtered_target_areas.where("#{TargetArea.table_name}.type like ?", "%#{@filters[:type]}%")
    end

    if @filters[:name]
      filtered_target_areas = filtered_target_areas.where("#{TargetArea.table_name}.name like ?", "%#{@filters[:name]}%")
    end

    if @filters[:state]
      filtered_target_areas = filtered_target_areas.where("#{TargetArea.table_name}.state = ?", "#{@filters[:state]}")
    end

    if @filters[:country]
      filtered_target_areas = filtered_target_areas.where("#{TargetArea.table_name}.country = ?", "#{@filters[:country]}")
    end

    if @filters[:latitude].present? && @filters[:longitude].present? && @filters[:radius].present?
      filtered_target_areas = filtered_target_areas.where("(3963 * ACOS(COS(RADIANS(:lat)) * COS(RADIANS(latitude)) * COS(RADIANS(longitude) - RADIANS(:lon)) + SIN(RADIANS(:lat)) * SIN(RADIANS(latitude)))) < :radius",
                                            {lat: @filters[:latitude], lon: @filters[:longitude], radius: @filters[:radius]})
    end
    filtered_target_areas
  end
end
