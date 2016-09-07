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
end
