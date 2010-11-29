module ApplicationHelper
  def display_birthday(bday)
    bday.month.to_s + "/" + bday.day.to_s
  end
  
  def display_date(date)
    display_birthday(date) + "/" + date.year.to_s
  end
  
  def random_banner_image
    num = SecureRandom.random_number(11)
    num.to_s + ".jpg"
  end
end
