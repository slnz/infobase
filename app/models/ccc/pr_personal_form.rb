class Ccc::PrPersonalForm < ActiveRecord::Base


  self.table_name = "pr_personal_forms"

  belongs_to :person, class_name: "Ccc::Person"

  def submit!
  end
end
