module Votable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end
  
  # Returns total user votes
  def total
    votes.sum(:value)
  end
  
  # Sets user's vote (like or dislike)
  def set_evaluate(user, value)
    votes.create(user: user, value: value)    
  end
  
  # Changes user's vote
  def change_evaluate(user)
    votes.where(user: user).update_all("value = (-1) * value")
    votes.reload
  end  
  
  # Cancel user's vote
  def cancel_evaluate(user)
    votes.where(user: user).delete_all
  end
  
  # Return true if user voted
  def user_voted?(user)
    votes.where(user: user).exists?
  end
  
  # Return true if user isn't author of question or answer
  def user_can_vote?(user)
    user.id != user_id
  end
  
  # Return true if user set like
  def like_by?(user)
    votes.where(user: user, value: 1).present?
  end
end