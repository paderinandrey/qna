# require 'rails_helper'
# require 'capybara/email'

# RSpec.describe Devise::OmniauthCallbacksController, type: :controller do
 
#   describe "for annonymous user" do
#     context "when facebook account doesn't exist in the own system" do
#       before(:each) do
#         mock_auth_hash[:facebook]
#         session['devise.omniauth_data'] = OmniAuth.config.mock_auth[:facebook]
#         get :facebook
#         @user = User.where(email: "test@test.com").first
#       end
    
#       it { expect(@user).to_not be_nil }
    
#       it "should create authentication with facebook id" do
#         authentication = @user.authentications.where(provider: "facebook", uid: "12345").first
#         expect(authentication).to_not be_nil
#       end
    
#       it { expect(@user).to be_user_signed_in }
    
#       it { expect(response).to redirect_to root_url }
#     end
#   end
# end
