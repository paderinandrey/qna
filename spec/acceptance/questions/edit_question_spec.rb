require_relative '../acceptance_helper'

feature 'Edit question', %q{
  In order to get specify question
  As an authenticated user
  I want to be able to edit question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:alien_user) { create(:user) }
  given(:alien_question) { create(:question, user: alien_user) }

  scenario 'Authenticated user edit question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Edit'
    fill_in 'Title', with: 'new title'
    fill_in 'Body', with: 'new body'
    click_on 'Save'

    expect(page).to have_content 'Question was successfully updated.'
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

    expect(page).to have_content 'Question could not be updated.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user ties to create question' do
    visit question_path(question)

    expect(page).to have_no_link("Edit", href: question_path(alien_question))
  end

  scenario 'Alien user ties to edit question' do
    sign_in(user)

    visit question_path(alien_question)

    expect(page).to have_no_link("Edit", href: question_path(alien_question))
  end
end
