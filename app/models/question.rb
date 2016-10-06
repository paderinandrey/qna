class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable
  
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  default_scope  { order(id: :asc) }
  
  validates :title, :body, :user_id, presence: true
end
