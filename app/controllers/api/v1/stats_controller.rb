module Api
  module V1
    class StatsController < ApplicationController
      respond_to :json
      
      def activity
        activity = Activity.find(params[:activity_id])
        
        begin_date = Date.parse(params[:begin_date])
        end_date = Date.parse(params[:end_date])
        
        @stats = activity.get_stats_for_dates(begin_date, end_date)
        respond_with @stats
      end
      
      def show
        activity = Activity.find(params[:activity_id])
        
        date = Date.parse(params[:date])

        @stat = activity.get_stat_for(date)
        respond_with @stat
      end
    end
  end
end