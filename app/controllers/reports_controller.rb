class ReportsController < ApplicationController
  def do_report
    from_date = Date.civil(params["from(1i)"].to_i, params["from(2i)"].to_i, params["from(3i)"].to_i)
    to_date = Date.civil(params["to(1i)"].to_i, params["to(2i)"].to_i, params["to(3i)"].to_i)
    redirect_to national_report_path({:from => from_date, :to => to_date, :strategies => params[:strategies]})
  end
  
  def national_report
    if params[:from].blank? || params[:to].blank? || params[:strategies].blank?
      redirect_to create_report_path, :notice => "You must set the dates for the report and have at least one strategy checked."
    else
      @report_type = "National"
      @from_date = Date.parse(params[:from])
      @to_date = Date.parse(params[:to])
      @strategies_list = params[:strategies]
      @row_type = "Region"
      @report = InfobaseReport.create_national_report(@from_date, @to_date, @strategies_list)
      @rows = @report.rows
      @totals = @report.get_totals
      render :report
    end
  end
  
  def regional_report
    if params[:from].blank? || params[:to].blank? || params[:strategies].blank?
      redirect_to create_report_path, :notice => "You must set the dates for the report and have at least one strategy checked."
    else
      @report_type = "Regional"
      @region = params[:region]
      @from_date = Date.parse(params[:from])
      @to_date = Date.parse(params[:to])
      @strategies_list = params[:strategies]
      @row_type = "Team"
      @report = InfobaseReport.create_regional_report(@region, @from_date, @to_date, @strategies_list)
      @rows = @report.rows
      @totals = @report.get_totals
      render :report
    end
  end

  def team_report
    if params[:from].blank? || params[:to].blank? || params[:strategies].blank?
      redirect_to create_report_path, :notice => "You must set the dates for the report and have at least one strategy checked."
    else
      @report_type = "Missional Team"
      @team = Team.find(params[:team_id])
      @from_date = Date.parse(params[:from])
      @to_date = Date.parse(params[:to])
      @strategies_list = params[:strategies]
      @row_type = "Ministry Location"
      @report = InfobaseReport.create_team_report(@team, @from_date, @to_date, @strategies_list)
      @rows = @report.rows
      @totals = @report.get_totals
      render :report
    end
  end
end
