module ReportsHelper
  def create_zoom_in_link(row, row_type, from_date, to_date, strategies, type, team, status, format = "html")
    path = nil
    case row_type
    when "Region"
      if type == "campus"
        path = regional_report_path(row.key, {:from => from_date, :to => to_date, :strategies => strategies, :movementstatus => status, :event_type => type, :format => format})
      else
        path = team_report_path(row.key, {:from => from_date, :to => to_date, :strategies => strategies, :movementstatus => status, :event_type => type, :format => format})
      end
      path
    when "Team"
      path = team_report_path(row.key, {:from => from_date, :to => to_date, :strategies => strategies, :movementstatus => status, :event_type => type, :format => format})
    when "Ministry Location"
      path = location_report_path(row.key, {:from => from_date, :to => to_date, :strategies => strategies, :movementstatus => status, :event_type => type, :team_id => team, :format => format})
    end
    path
  end
end
