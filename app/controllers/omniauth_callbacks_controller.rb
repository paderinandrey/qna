class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth1(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'facebook') if is_navigational_format?
    end
  end
  
  def twitter
    auth = request.env["omniauth.auth"]
    @user = User.find_for_oauth1(auth)
    
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
  
  
  def linkedin
    auth = request.env["omniauth.auth"]
    @user = User.find_for_oauth1(auth)
    
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
  
  def provides_callback
    
  end
end
