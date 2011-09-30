class MovementReportsController < ApplicationController
  before_filter :setup
  before_filter :check_params, :except => [:create_report, :do_report]
  
  def create_report
    @regions = {"All" => "National"}.merge(Region.standard_regions_hash)
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
    @report_title = title(@type)
    @rows = InfobaseMovementReport.report(@type, @region, @date, @strategies_list, @order)
    @enrollment_total = sum_enrollment(@rows, @type)
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
  
  def title(type)
    result = ""
    case type
    when "movement"
      result = "Count of Movements"
    when "location"
      result = "Count of Ministry Locations"
    when "teamorg"
      result = "Count of Missional Teams Coached"
    when "teamgeo"
      result = "Count of Missional Teams With Movements"
    end
    result
  end
  
  def sum_enrollment(rows, type)
    result = 0
    if (type == "location")
      rows.each do |row|
        result += row.target_area.enrollment.to_i
      end
    end
    result
  end
end
