class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  validates :body, :user_id, :commentable_type, :commentable_id, presence: true
  
  validates_inclusion_of :commentable_type, in: ['Question', 'Answer']
  
  def question_id
    commentable.class == Question ? commentable.id : commentable.question_id
  end 
end
