require 'rails_helper'

feature 'Delete question', %q{
  In order to get specify question
  As an authenticated user
  I want to be able to edit question
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  scenario 'Authenticated user edit question' do
    sign_in(user)
    
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Your question has been successfully deleted!'
    expect(current_path).to eq questions_path
  end
  
  scenario 'Non-authenticated user ties to delete question' do
    visit question_path(question)
    click_on 'Delete'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
