class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  
  default_scope { order(best: :desc, created_at: :asc) }
  
  def switch_best
    Answer.transaction do
      self.question.best_answers.update(best: false) unless self.best?
      self.best = !self.best
      self.save!
    end  
  end
end
