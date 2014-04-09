class FixNoHttpLinks < ActiveRecord::Migration
  def change
    TargetArea.find_each do |ta|
      [ :url, :urlToLogo, :ciaUrl, :infoUrl ].each do |c|
        val = ta.send(c)
        if val.present? && !val.starts_with?("http://") && !val.starts_with?("https://")
          puts "TargetArea #{ta.id} #{val} -> http://#{val}"
          ta.update_column(c, "http://#{val}")
        end
      end
    end
    Activity.find_each do |a|
      [ :url ].each do |c|
        val = a.send(c)
        if val.present? && !val.starts_with?("http://") && !val.starts_with?("https://")
          puts "Activity #{a.id} #{val} -> http://#{val}"
          a.update_column(c, "http://#{val}")
        end
      end
    end
  end
end
