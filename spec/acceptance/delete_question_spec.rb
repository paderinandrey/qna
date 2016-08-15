require 'rails_helper'

feature 'Delete question', %q{
  In order to ???
  As an authenticated user
  I want to be able to delete question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:alien_user) { create(:user) }
  given(:alien_question) { create(:question, user: alien_user) }

  scenario 'Authenticated user delete question' do
    sign_in(user)

    visit question_path(question)
    click_link('Delete', href: question_path(question))

    expect(page).to have_content 'Your question has been successfully deleted!'
    expect(page).to have_no_content question.title
    expect(page).to have_no_content question.body
    expect(current_path).to eq questions_path
  end

  scenario 'Non-authenticated user ties to delete question' do
    visit question_path(question)

    expect(page).to have_no_link("Delete", href: question_path(question))
    expect(page).to have_no_xpath "//a[@href='#{question_path(question)}'][@data-method='delete']"
  end

  scenario 'Alien user ties to delete question' do
    sign_in(user)

    visit question_path(alien_question)

    expect(page).to have_no_link("Delete", href: question_path(alien_question))
    expect(page).to have_no_xpath "//a[@href='#{question_path(alien_question)}'][@data-method='delete']"
  end
end
