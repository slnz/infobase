module ApplicationHelper
  def display_date_short(bday)
    if bday
      bday.month.to_s + "/" + bday.day.to_s
    else
      ""
    end
  end
  
  def display_date(date)
    if date
      display_date_short(date) + "/" + date.year.to_s
    else
      ""
    end
  end
  
  def display_date_dash(date)
    if date
      date.year.to_s + "-" + date.month.to_s + "-" + date.day.to_s
    else
      ""
    end
  end
  
  def random_banner_image
    num = SecureRandom.random_number(11)
    num.to_s + ".jpg"
  end
  
  def display_website(website)
    if !website.blank?
      website.start_with?("http") ? website : "http://" + website
    else
      ""
    end
  end
  
  def activity_size(activity)
    result = "N/A"
    if activity.is_active? && activity.statistics.last 
      result = activity.statistics.last.invldStudents
    end
    result
  end

  def last_august
    d = Date.today
    year = d.year
    if d.month <= 8
      year = d.year - 1
    end
    result = Date.parse("#{year}-08-01")
    result
  end
  
  def spinner(extra = nil)
    e = extra ? "spinner_#{extra}" : 'spinner'
    image_tag('spinner.gif', :id => e, :style => 'display:none', :class => 'spinner')
  end
end
