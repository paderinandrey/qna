class UsersController < ApplicationController
  authorize_resource
  
  def confirm_email
    auth = session['devise.omniauth_data']
    if auth == nil
      flash[:notice] = "Please sign up to continue."
      redirect_to new_user_registration_url
    else
      User.transaction do
        @user = User.generate(user_params)
        @user.save!
        @user.create_authorization(auth['provider'], auth['uid'])
      end
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Signed in successfully via #{ auth['provider'].capitalize }." 
      flash[:notice] = "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account." 
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
