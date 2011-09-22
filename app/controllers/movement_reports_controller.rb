class MovementReportsController < ApplicationController
  before_filter :setup
  before_filter :check_params, :except => [:create_report, :do_report]
  
  def create_report
    @regions = {"All (will take a minute or two)" => "National"}.merge(Region.standard_regions_hash)
    @strategies = Activity.visible_strategies
  end

  def do_report
    date = Date.civil(params["date(1i)"].to_i, params["date(2i)"].to_i, params["date(3i)"].to_i)
    redirect_to movement_report_path({:type => params[:type], :date => date, :strategies => params[:strategies], :order => params[:order], :regions => params[:region]})
  end
  
  def movement_report
    @type = params[:type]
    @date = params[:date]
    @strategies_list = params[:strategies]
    @order = params[:order]
    @region = params[:regions]
    if @region == "National"
      @region = Region.campus_region_codes
    end
    @report_title = "Count of Movements"
    @rows = InfobaseMovementReport.report(@type, @region, @date, @strategies_list, @order)
  end

  private

  def setup
    @menubar = "reports"
    @submenu = "movements"
  end

  def check_params
    if params[:date].blank? || params[:strategies].blank?
      redirect_to create_movement_report_path, :notice => "You must set the date for the report and have at least one strategy checked."
      return false;
    end
  end
end
