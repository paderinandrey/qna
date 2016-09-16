class Question < ApplicationRecord
  include Attachable
  include Votable
  #include Commentable
  
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, :body, :user_id, presence: true
end
