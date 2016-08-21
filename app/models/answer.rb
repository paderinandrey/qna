class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  
  def switch_best
    unless self.best?
      best_answers = Answer.where({ best: true, question_id: self.question })
      best_answers.update_all(best: false)
    end
    
    self.best = !self.best
    self.save
  end
end
