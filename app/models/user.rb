class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Returns true if the current user is owner of object
  def author_of?(object)
    object.user_id == id
  end
  
  # Return true if user voted
  def voted?(object)
    object.votes.where(user: self).exists?
  end
  
  # Returns true if the current user can vote for object
  def can_vote?(object)
    !author_of?(object) && !voted?(object)
  end
  
  # Return true if user set like
  def like?(object)
    object.votes.where(user: self, value: 1).present?
  end
end
