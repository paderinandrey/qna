class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check
  
  def facebook
    provides_callback
  end
  
  def twitter
    provides_callback
  end
  
  def linkedin
    provides_callback
  end
  
  private
  
  def provides_callback
    auth = request.env["omniauth.auth"]
    @user = User.find_for_oauth(auth)
    
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    elsif @user.new_record?
      session["devise.omniauth_data"] = { provider: auth.provider, uid: auth.uid.to_s }
      render action: :confirm_email, user: @user
    else
      session["devise.omniauth_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
