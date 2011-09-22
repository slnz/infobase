module MovementReportsHelper
  def expand_type(type)
    result = ""
    if type == "movement"
      result = "Movements"
    elsif type == "location"
      result = "Ministry Locations"
    elsif type == "teamorg" || type == "teamgeo"
      result = "Missional Teams"
    end
  end
  
  def expand_type_footer(type)
    result = ""
    if type == "movement"
      result = "Movements On Record"
    elsif type == "location"
      result = "Ministry Locations On Record"
    elsif type == "teamorg" || type == "teamgeo"
      result = "Missional Teams On Record"
    end
  end
  
  def extra_column_header(type)
    result = ""
    if type == "movement"
      result = "<td colspan='2' class='muster_cap'>Missional Team</td>".html_safe
    elsif type == "location"
      result = "<td class='muster_cap'>Enrollment</td>".html_safe
    end
  end
  
  def movement_sort_options
    result = {}
    result["Campus Name"] = "campus"
    result["City/State"] = "city"
    result["Missional Team Name"] = "team"
    result["Region"] = "region"
    result["Status"] = "status"
    result["Ministry"] = "ministry"
    result
  end
  
  def coached_sort_options
    result = {}
    result["Campus Name"] = "campus"
    result["City/State"] = "city"
    result["Region"] = "region"
    result
  end
  
  def active_sort_options
    result = {}
    result["City/State"] = "city"
    result["Missional Team Name"] = "team"
    result["Region"] = "region"
    result    
  end
end
