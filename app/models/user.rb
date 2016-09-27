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
  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    
    email = auth.info[:email]
    name = auth.info[:name]
    user = User.where(email: email).first if email
    
    if user
      user.create_authorization(auth.provider, auth.uid)
    else
      return User.new(name: name) if email.blank?
      
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password, name: name)
      user.skip_confirmation!
      User.transaction do  
        user.save!
        user.create_authorization(auth.provider, auth.uid)
      end
    end
    user
  end
  
  #
  def create_authorization(provider, uid)
    self.authorizations.create!(provider: provider, uid: uid)
  end

  # 
  def username
    name.blank? ? email : name
  end
  
  #
  def self.generate(params)
    user = new(params)
    user.password = Devise.friendly_token[0, 20]
    user
  end
end
