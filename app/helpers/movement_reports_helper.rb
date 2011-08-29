module MovementReportsHelper
  def movement_sort_options
    result = {}
    result["Campus Name"] = "campus"
    result["City/State"] = "city"
    result["Missional Team Name"] = "team"
    result["Region"] = "region"
    result["Status"] = "status"
    result["Ministry"] = "strategy"
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
