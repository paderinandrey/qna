class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    #render json: request.env['omniauth.auth']
    @user = User.find_for_oauth1(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'facebook') if is_navigational_format?
    end
  end
  
  def twitter
    # @user = User.find_for_oauth(request.env['omniauth.auth'])
    # if @user.persisted?
    #   sign_in_and_redirect @user, event: :authentication
    #   set_flash_message(:notice, :success, kind: 'twitter') if is_navigational_format?
    # end
    #render json: request.env['omniauth.auth']
    auth = request.env["omniauth.auth"]
    
    #puts "------"
    #puts auth.select { |key,_| [:provider, :uid].include? key }
    
    @user = User.find_for_oauth(auth, current_user)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'twitter') if is_navigational_format?
    else
    #@auth = Authorization.find_for_oauth(env["omniauth.auth"])
    #session['omniauth.data'] = env["omniauth.auth"] 
    session["devise.omniauth_data"] = { provider: auth.provider, uid: auth.uid.to_s }
    #puts '----------------+-----'
    #puts @user.name
    
    
    
    render action: :confirm_email, user: @user
    
    end
    #render template: 'devise/registrations/new', locals: { user: @user }
    #redirect_to confirm_email_path#@user#:template => :confirm_email, :locals => {user: @user}
   
    #if @user.email.blank?
       
    #end
  # redirect_to finish_signup_path(@user)
   
   
    # if @user.persisted?
    #   sign_in_and_redirect @user, event: :authentication
    #   set_flash_message(:notice, :success, kind: 'twitter') if is_navigational_format?
      
    # else
    #   session["devise.twitter_data"] = env["omniauth.auth"]
    #   redirect_to new_user_registration_url
    # end
  end
  
  

  #def confirm_email
   # puts '***********++++++++++***********'
  #end
  # def after_sign_in_path_for(resource)
  #   if resource.need_confirmation?
  #     puts "---------------"
  #     puts resource.need_confirmation
      
  #     confirm_email_path(resource)
  #   else
  #     super resource
  #   end
  # end
  

end
