class UsersController < ApplicationController
  # before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]
  
  # #respond_to :html
  # # GET /users/:id.:format
  # def show
  #   # authorize! :read, @user
  # end

  # # GET /users/:id/edit
  # def edit
  #   # authorize! :update, @user
  # end

  # PATCH/PUT /users/:id.:format
  # def update
  #   # authorize! :update, @user
  #   respond_to do |format|
  #     if @user.update(user_params)
  #       sign_in(@user == current_user ? @user : current_user, :bypass => true)
  #       format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # GET/PATCH /users/:id/finish_signup
  # def finish_signup
  #   # authorize! :update, @user 
  #   # puts "--------------------+-"
  #   # puts params[:user][:new_email]
  #   # puts "---------------------"
  #   # unconfirmed_email = params[:user][:new_email]
  #   # @user.update(unconfirmed_email: unconfirmed_email)
  #   # ComfirmUserEmailMailer.confirm_email(@user, unconfirmed_email).deliver_now
  #   # if request.patch? && params[:user] #&& params[:user][:email]
  #   #   if @user.update(user_params)
  #   #     @user.skip_reconfirmation!
  #   #     sign_in(@user, :bypass => true)
  #   #     redirect_to @user, notice: 'Your profile was successfully updated.'
  #   #   else
  #   #     @show_errors = true
  #   #   end
  #   # end
  # end

  def confirm_email
    auth = session['devise.omniauth_data']
    @user = User.create!(user_params)
    @user.create_authorization(auth['provider'], auth['uid'])
    sign_in(@user, bypass_sign_in: true)
    redirect_to root_url
  end

  # GET/PATCH /users/:id/confirm_email 
  #def confirm_email
    #
    #user = User.find_by_confirm_token(params[:id])
    #puts user.name
    # if user
    #   user.email_activate
    #   flash[:success] = "Welcome to the Sample App! Your email has been confirmed.
    #   Please sign in to continue."
    #   redirect_to signin_url
    # else
    #   flash[:error] = "Sorry. User does not exist"
    #   redirect_to root_url
    # end
    
    # if request.patch? && params[:user] #&& params[:user][:email]
    #   if @user.update(user_params)
    #     #@user.skip_reconfirmation!
    #     sign_in(@user, :bypass => true)
    #     redirect_to @user, notice: 'Your profile was successfully updated.'
    #   else
    #     @show_errors = true
    #   end
    # end
  #end

  # # DELETE /users/:id.:format
  # def destroy
  #   # authorize! :delete, @user
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to root_url }
  #     format.json { head :no_content }
  #   end
  # end
  
  private
    def user_params
      accessible = [:name, :email]
      accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end