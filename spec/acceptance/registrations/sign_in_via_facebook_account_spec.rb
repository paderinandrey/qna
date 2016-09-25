require_relative '../acceptance_helper'

feature 'User sign in via Facebook account', %q{
  In order to be able to ask question
  As an user
  I want to able to sign in via Facebook account
} do
  
  describe "Access via Facebook account" do
    before(:each) do
      mock_auth_hash[:facebook]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end
    
    scenario 'Registered user tries sign in via facebook' do
      visit new_user_session_path
      click_on('Sign in with Facebook')
      
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end
    
    scenario 'Non-registered user tries sign in facebook' do
      visit new_user_session_path
      click_on('Sign in with Facebook')
      
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end
  end
end
