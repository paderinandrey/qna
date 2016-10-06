class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :question_id, :user_id, presence: true
end
