class UsersController < ApplicationController

  def confirm_email
    auth = session['devise.omniauth_data']
    User.transaction do
      @user = User.create!(user_params)
      @user.create_authorization(auth['provider'], auth['uid'])
    end
    sign_in_and_redirect @user, event: :authentication
    flash[:success] = "Signed in successfully via #{ auth['provider'].capitalize }." 
  end

  private
    def user_params
      accessible = [:name, :email]
      accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end