class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :user
  
  validates :body, presence: true
  validates :user_id, presence: true
end
