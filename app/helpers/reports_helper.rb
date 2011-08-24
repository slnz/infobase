module ReportsHelper
  def create_zoom_in_link(row, row_type, from_date, to_date, strategies, team = nil)
    path = nil
    case row_type
    when "Region"
      path = regional_report_path(row.key, {:from => from_date, :to => to_date, :strategies => strategies})
    when "Team"
      path = team_report_path(row.key, {:from => from_date, :to => to_date, :strategies => strategies})
    when "Ministry Location"
      path = location_report_path(row.key, {:from => from_date, :to => to_date, :strategies => strategies, :team_id => team})
    end
    path
  end
end
