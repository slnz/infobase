class FixNoHttpLinksInTeam < ActiveRecord::Migration
  def change
    Team.find_each do |t|
      if t.url.present? && !t.url.starts_with?("http://") && !t.url.starts_with?("https://")
        puts "Team #{t.id} #{t.url} -> http://#{t.url}"
        t.update_column(:url, "http://#{t.url}")
      end
    end
  end
end
