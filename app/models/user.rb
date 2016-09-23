class User < ApplicationRecord
  #before_create :confirmation_token
  #TEMP_EMAIL_PREFIX = 'change@me'
  #TEMP_EMAIL_REGEX = /\Achange@me/
  
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, 
         :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

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
    user = User.where(email: email).first
    
    if user
      user.create_authorization(auth.provider, auth.uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation!
      user.save!
      user.create_authorization(auth.provider, auth.uid)
    end
   
    user
  end
  
  def create_authorization(provider, uid)
    self.authorizations.create(provider: provider, uid: uid)
  end
  
  # def email_required?
  #   super && provider.blank?
  # end
  
  #validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  
  def self.find_for_oauth(auth)

    # Get the identity and user if they exist
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    #user = signed_in_resource ? signed_in_resource : authorization.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email

      # Create the user if it's a new registration
      if user.nil?
        
          puts "**************"
          puts auth.extra.raw_info.name
          puts "**************"
        
        user = User.new(
          name: auth.extra.raw_info.name,
          #need_confirmation: true,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        #user.confirmation!
       # user.save!
      end
    end

    # Associate the identity with the user if needed
    # if authorization.user != user
    #   authorization.user = user
    #   authorization.save!
    # end
    user
  end
  
  # def email_verified?
  #   self.email && self.email !~ TEMP_EMAIL_REGEX
  # end


  # def email_activate
  #   self.email_confirmed = true
  #   self.email = unconfirmed_email
  #   self.confirm_token = nil
  #   save!(validate: false)
  # end

  # private
  # def confirmation_token
  #   if self.confirm_token.blank?
  #       self.confirm_token = SecureRandom.urlsafe_base64.to_s
  #   end
  # end
end
