class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :user
  
  validates :body, :user_id, presence: true
  
  def to_builder # или лучше будет сделать через темплэйт *.json.jbuilder?
    jbuilder = Jbuilder.new do |comment|
      comment.id id
      comment.body body
      comment.commentable_type commentable_type.downcase
      comment.commentable_id commentable_id
    end
    jbuilder.target!
  end
end
