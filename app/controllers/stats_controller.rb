class StatsController < ApplicationController
  def location
    @current_week = Time.now.beginning_of_week - 1.day # beginning of week returns Monday, and we want Sunday
  end
end
