require_relative '../acceptance_helper'

feature 'User sign in via Twitter account', %q{
  In order to be able to ask question
  As an user
  I want to able to sign in via Twitter account
} do
  
  describe "Access via Twitter account" do
    before(:each) do
      mock_auth_hash[:twitter]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    end
    
    scenario 'Registered user tries sign in via twitter' do
      
      visit new_user_session_path
      click_on('Sign in with Twitter')
      
      expect(page).to have_content 'Please confirm your email address after continue.'
      fill_in 'Email', with: 'test@test.com' 
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on('Continue')
      
      open_email('test@test.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
      
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end
    
    scenario 'Non-registered user tries sign in twitter' do
      visit new_user_session_path
      click_on('Sign in with Twitter')
      
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end
  end
  
end
