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
      if @filters[:period_end]
        from_date = Date.parse(@filters[:period_begin]).beginning_of_week(:sunday)
        to_date = Date.parse(@filters[:period_end]).beginning_of_week(:sunday)

        filtered_statistics = filtered_statistics.collate_values(from_date, to_date)
      else
        filtered_statistics = filtered_statistics.where("#{Statistic.table_name}.periodBegin" => Date.parse(@filters[:period_begin]).beginning_of_week(:sunday))
      end
    end

    if @filters[:activity_id]
      filtered_statistics = filtered_statistics.where("#{Statistic.table_name}.fk_Activity IN(?)", @filters[:activity_id].split(','))
    end

    if @filters[:target_area_id]
      filtered_statistics = filtered_statistics.joins(:activity).where("#{Activity.table_name}.fk_targetAreaID IN(?)", @filters[:target_area_id].split(','))
    end

    if @filters[:movement_status]
      filtered_statistics = filtered_statistics.joins(:activity).where("#{Statistic.table_name}.status IN(?)", @filters[:movement_status].split(','))
    end

    filtered_statistics
  end
end