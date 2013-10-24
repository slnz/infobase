class MinistryFilter
  attr_accessor :ministries, :filters

  def initialize(filters)
    @filters = filters || {}

    # strip extra spaces from filters
    @filters.collect { |k, v| @filters[k] = v.to_s.strip }
  end

  def filter(ministries)
    filtered_ministries = ministries

    if @filters[:name]
      filtered_ministries = filtered_ministries.where("#{Ministry.table_name}.name" => @filters[:name])
    end

    filtered_ministries
  end
end