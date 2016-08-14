class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, presence: true
end
