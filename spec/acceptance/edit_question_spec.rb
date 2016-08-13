require 'rails_helper'

feature 'Edit question', %q{
  In order to get specify question
  As an authenticated user
  I want to be able to edit question
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  scenario 'Authenticated user edit question' do
    sign_in(user)
    
    visit question_path(question)
    click_on 'Edit'
    fill_in 'Title', with: 'new title'
    fill_in 'Body', with: 'new body'
    click_on 'Save'
    
    expect(page).to have_content 'Your question has been updated successfully.'
    expect(page).to have_content 'new title'
    expect(page).to have_content 'new body'
    expect(current_path).to eq question_path(question)
  end
  
  scenario 'Authenticated user edit question with empty title' do
    sign_in(user)
    
    visit question_path(question)
    click_on 'Edit'
    fill_in 'Title', with: ''
    fill_in 'Body', with: 'new body'
    click_on 'Save'
    
    expect(page).to have_content "Title can't be blank"
    expect(current_path).to eq question_path(question)
  end
  
  scenario 'Authenticated user create question with empty body' do
    sign_in(user)
    
    visit question_path(question)
    click_on 'Edit'
    fill_in 'Title', with: 'new title'
    fill_in 'Body', with: ''
    click_on 'Save'
    
    expect(page).to have_content "Body can't be blank"
    expect(current_path).to eq question_path(question)
  end
  
  scenario 'Non-authenticated user ties to create question' do
    visit question_path(question)
    click_on 'Edit'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
