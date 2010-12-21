module LocationsHelper
  def display_website(website)
    if website
      website.include?("http://") ? website : "http://" + website
    else
      ""
    end
  end
end
