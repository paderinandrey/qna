class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable
  
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  default_scope  { order(id: :asc) }
  scope :from_yesterday, -> { where(created_at: (Time.now - 1.day).beginning_of_day.utc..(Time.now - 1.day).end_of_day.utc) }
  
  validates :title, :body, :user_id, presence: true
  
  after_create :create_subscription_for_author
  
  # creates subscription for author of question
  def create_subscription_for_author
    user.subscribe_to(self)
  end
end
