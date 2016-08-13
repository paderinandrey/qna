require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do
  
  given(:user) { create(:user) }
  
  scenario 'Authenticated user creates question' do
    sign_in(user)
    
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'
    
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test body'
    expect(current_path).to eq question_path(Question.last)
  end
  
  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    click_on 'Ask question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
  
  scenario 'Authenticated user create question with empty title' do
    sign_in(user)
    
    visit questions_path
    click_on 'Ask question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'
    
    expect(page).to have_content "Title can't be blank"
    expect(current_path).to eq questions_path
  end
  
  scenario 'Authenticated user create question with empty body' do
    sign_in(user)
    
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'test'
    click_on 'Create'
    
    expect(page).to have_content "Body can't be blank"
    expect(current_path).to eq questions_path
  end
end
