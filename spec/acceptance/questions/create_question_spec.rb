require_relative '../acceptance_helper'

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

  scenario 'Authenticated user create question with invalid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'

    expect(page).to have_content "Question could not be created."
    expect(current_path).to eq questions_path
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path

    expect(page).to have_no_link('Ask question')
  end
end
