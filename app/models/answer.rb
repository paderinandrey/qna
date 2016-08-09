class Answer < ApplicationRecord
  belongs_to :question, touch: true
  
  validates :body, :question_id, presence: true
end
