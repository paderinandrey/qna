class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true
  
  default_scope { order(best: :desc, created_at: :asc) }
  scope :best, -> { where(best: true) }
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  
  def switch_best
    Answer.transaction do
      self.question.answers.best.update_all(best: false) unless self.best?
      self.update!(best: !best)
    end  
  end
end
