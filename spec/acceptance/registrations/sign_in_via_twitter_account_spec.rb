require_relative '../acceptance_helper'

feature 'User sign in via Twitter account', %q{
  In order to be able to ask question
  As an user
  I want to able to sign in with Twitter account
} do
  
  describe "Sign in with Twitter account first time" do
    background do
      clear_emails
      mock_auth_hash[:twitter]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    end
    
    scenario 'User tries sign in with Twitter first time' do
      visit new_user_session_path
      click_on('Sign in with Twitter')
      
      expect(page).to have_content 'Please confirm your email address after continue.'
      fill_in 'Email', with: 'test@test.com' 
      click_on('Continue')
      
      expect(page).to have_content 'Signed in successfully via Twitter.'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
      expect(current_path).to eq root_path
      
      open_email('test@test.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end
    
  describe "Sign in with Twitter account subsequent times" do  
    given(:user) { create(:user) }
    given!(:twitter_authorization) { create(:twitter_authorization, user: user) }
    
    scenario 'Registered user tries sign in with twitter' do
      visit new_user_session_path
      click_on('Sign in with Twitter')
      
      expect(page).to_not have_content 'Please confirm your email address after continue.'  
      expect(page).to_not have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end
  end
  
end
