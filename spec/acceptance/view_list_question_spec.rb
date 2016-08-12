require 'rails_helper'

feature 'View list of questions', %q{
  In order to get find answer
  As an user
  I want to be able to view list of question
} do
    
  given(:user) { create(:user) }
  
  scenario 'Authenticated user view list of questions' do
    sign_in(user)
    visit questions_path
    
    expect(current_path).to eq questions_path
  end
  
  scenario 'Non-authenticated user ties to view list of questions' do
    visit questions_path
    
    expect(current_path).to eq questions_path
  end
end