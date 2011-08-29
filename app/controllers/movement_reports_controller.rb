class MovementReportsController < ApplicationController
  before_filter :setup
  
  def create_report
    @regions = {"All (will take a minute or two)" => "National"}.merge(Region.standard_regions_hash)
    @strategies = Activity.visible_strategies
  end

  private

  def setup
    @menubar = "reports"
    @submenu = "movements"
  end
end
