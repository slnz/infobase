
class Ccc::PrQuestionSheet < ActiveRecord::Base
  #has_one :question_sheet_pr_info, :dependent => :destroy
  has_many :reviews, class_name: 'Ccc::PrReview'
  has_many :personal_forms, class_name: "Ccc::PrPersonalForm"
end
