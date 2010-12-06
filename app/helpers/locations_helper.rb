module LocationsHelper
  def display_website(website)
    website.include?("http://") ? website : "http://" + website
  end
end
