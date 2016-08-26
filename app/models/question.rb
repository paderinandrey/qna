class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments
  has_many :best_answers, -> { where(best: true) }, class_name: Answer

  validates :title, :body, :user_id, presence: true
  
  #scope :best_answers, -> { joins(:answers).where('answers.best = true') }
end
