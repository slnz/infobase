class ReportsController < ApplicationController
  def do_report
    @report_type = "National"
    @from_date = params[:from]
    @to_date = params[:to]
    @strategies_list = params[:strategies]
    @row_type = "Region"
    @rows = []
    @totals = Statistic.new
  end
end
