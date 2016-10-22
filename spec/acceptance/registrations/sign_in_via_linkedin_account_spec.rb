require_relative '../acceptance_helper'

feature 'User sign in via linkedin account', %q{
  In order to be able to ask question
  As an user
  I want to able to sign in via Linkedin account
} do
  
  describe "Access via Linkedin account" do
    before(:each) do
      mock_auth_hash[:linkedin]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:linkedin]
    end
    
    scenario 'Registered user tries sign in via linkedin' do
      visit new_user_session_path
      click_on('Sign in with Linkedin')
      
      expect(page).to have_content 'Successfully authenticated from Linkedin account.'
      expect(current_path).to eq root_path
    end
    
    scenario 'Non-registered user tries sign in linkedin' do
      visit new_user_session_path
      click_on('Sign in with Linkedin')
      
      expect(page).to have_content 'Successfully authenticated from Linkedin account.'
      expect(current_path).to eq root_path
    end
  end
end
