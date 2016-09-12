class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable
  
  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  
  default_scope { order(best: :desc, created_at: :asc) }
  scope :best, -> { where(best: true) }
  
  # Changes :best value on opposite
  def switch_best
    Answer.transaction do
      self.question.answers.best.update_all(best: false) unless self.best?
      self.update!(best: !best)
    end  
  end
end
