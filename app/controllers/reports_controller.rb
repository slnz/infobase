class ReportsController < ApplicationController
  def do_report
    @report_type = "National"
    @from_date = Date.civil(params["from(1i)"].to_i, params["from(2i)"].to_i, params["from(3i)"].to_i)
    @to_date = Date.civil(params["to(1i)"].to_i, params["to(2i)"].to_i, params["to(3i)"].to_i)
    @strategies_list = params[:strategies]
    @row_type = "Region"
    @report = InfobaseReport.create_national_report(@from_date, @to_date, @strategies_list)
    @rows = @report.rows
    @totals = @report.get_totals
  end
end
