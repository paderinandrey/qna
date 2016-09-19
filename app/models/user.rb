class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

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
  
  #
  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    
    email = auth.info[:email]
    user = User.where(email: email).first
    
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end
  
  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
