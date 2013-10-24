class StatisticFilter
  attr_accessor :statistics, :filters

  def initialize(filters)
    @filters = filters || {}

    # strip extra spaces from filters
    @filters.collect { |k, v| @filters[k] = v.to_s.strip }
  end

  def filter(statistics)
    filtered_statistics = statistics

    if @filters[:period_begin]
      filtered_statistics = filtered_statistics.where("#{Statistic.table_name}.periodBegin" => Date.parse(@filters[:period_begin]).beginning_of_week(:sunday))
    end

    if @filters[:activity_id]
      filtered_statistics = filtered_statistics.where("#{Statistic.table_name}.fk_Activity IN(?)", @filters[:activity_id].split(','))
    end

    filtered_statistics
  end
end