class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, 
         :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter, :linkedin]

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
  def self.find_for_oauth1(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    
    email = auth.info[:email]
    user = User.where(email: email).first if email
    
    if user
      user.create_authorization(auth.provider, auth.uid)
    else
      if email.blank?
        return User.new(
          name: auth.extra.raw_info.name,
          password: Devise.friendly_token[0,20])
      else
        password = Devise.friendly_token[0, 20]
        user = User.new(email: email, password: password, password_confirmation: password)
        user.skip_confirmation!
        user.save!
        user.create_authorization(auth.provider, auth.uid)
      end
    end
    user
  end
  
  def create_authorization(provider, uid)
    self.authorizations.create(provider: provider, uid: uid)
  end

  def self.find_for_oauth(auth)

    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first if email
    # Create the user if needed
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email

      # Create the user if it's a new registration
      if user.nil?

        user = User.new(
          name: auth.extra.raw_info.name,
          password: Devise.friendly_token[0,20]
        )
      end
    end
    user
  end
end
