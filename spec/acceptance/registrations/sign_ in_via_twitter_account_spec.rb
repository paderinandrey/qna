require_relative '../acceptance_helper'

feature 'User sign in via Twitter account', %q{
  In order to be able to ask question
  As an user
  I want to able to sign in via Twitter account
} do
  
  describe "Access via twitter account" do
    it '' do
      visit new_user_session_path
      click_on('Sign in with Twitter')
      
    end
  end
  
end
