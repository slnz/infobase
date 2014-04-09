class AddAbbreviationToMinistry < ActiveRecord::Migration
  def change
    add_column :ministries, :abbreviation, :string
    strategies =     {
      "FS" => "Campus Field Ministry",
      "AA" => "Athletes In Action",
      "BR" => "Bridges",
      "SV" => "Cru High School",
      "ID" => "Destino", 
      "IC" => "Ethnic Field Ministry",
      "IE" => "Epic",
      "EV" => "Events",
      "FC" => "Faculty Commons",
      "FD" => "Fund Development",
      "WS" => "Global Missions",
      "GK" => "Greek",
      "II" => "Impact",
      "KN" => "Keynote",
      "KC" => "Korea CCC",
      "HR" => "Leadership Development",
      "ND" => "National",
      "IN" => "Nations",
      "OP" => "Operations",
      "SA" => "SALT",
      "VL" => "Valor",
      "OT" => "Other"
    }

    Ministry.where(name: 'Campus Ministry').update_all(name: 'Campus Field Ministry')
    Ministry.where(name: 'AIA').update_all(name: 'Athletes In Action')

    strategies.each do |abbreviation, name|
      ministry = Ministry.where(name: name).first
      if ministry
        ministry.update_column(:abbreviation, abbreviation)
      end
    end
  end
end
