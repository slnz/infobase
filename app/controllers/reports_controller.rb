class ReportsController < ApplicationController
  before_filter :setup
  before_filter :check_params, :except => [:create_report, :do_report]
  before_filter :get_dates_strategies, :except => [:create_report, :do_report]
  
  def create_report
    @strategies = Activity.event_strategies
  end
  
  def do_report
    from_date = Date.civil(params["from(1i)"].to_i, params["from(2i)"].to_i, params["from(3i)"].to_i)
    to_date = Date.civil(params["to(1i)"].to_i, params["to(2i)"].to_i, params["to(3i)"].to_i) + 1.month - 1.day
    redirect_to national_report_path({:from => from_date, :to => to_date, :strategies => params[:strategies], :event_type => params[:event_type]})
  end
  
  def national_report
    @report_type = @type.capitalize + " National"
    @reports = [InfobaseReport.create_national_report(@from_date, @to_date, @strategies_list, @type)]
    render :report
  end
  
  def regional_report
    @region = params[:region]
    @report_type = Region.full_name(@region).to_s + " Regional"
    @reports = [InfobaseReport.create_regional_report(@region, @from_date, @to_date, @strategies_list)]
    render :report
  end

  def team_report
    if @type == "campus"
      @team = Team.find(params[:team_id])
      @region = @team.region
      @report_type = @type.capitalize + " " + @team.name.to_s + " Missional Team"
    else 
      @region = params[:team_id]
      @report_type = @type.capitalize + " " + Region.full_name(@region).to_s + " Regional"
    end
    @reports = [InfobaseReport.create_team_report(@team, @from_date, @to_date, @strategies_list, @type, @region)]
    render :report
  end
  
  def location_report
    @location = TargetArea.find(params[:location_id])
    @team = Team.find(params[:team_id]) if params[:team_id]
    @region = @team.region if @team
    @report_type = @location.name.to_s + " Ministry Location"
    @reports = InfobaseReport.create_location_reports(@location, @from_date, @to_date, @strategies_list, @type, @team)
    render :report
  end
  
  private
  
  def setup
    @menubar = "reports"
    @submenu = "reports"
  end
  
  def check_params
    if params[:from].blank? || params[:to].blank? || params[:strategies].blank?
      redirect_to create_report_path, :notice => "You must set the dates for the report and have at least one strategy checked."
      return false;
    elsif params[:from] > params[:to]
      redirect_to create_report_path, :notice => "From date cannot be after To date."
      return false;
   end
  end
  
  def get_dates_strategies
    @from_date = Date.parse(params[:from])
    @to_date = Date.parse(params[:to])
    @strategies_list = params[:strategies]
    @type = params[:event_type]
  end
end
