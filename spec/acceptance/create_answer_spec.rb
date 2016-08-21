require_relative 'acceptance_helper'

feature 'Create answer to question', %q{
  In order to help
  As an authenticated user
  I want to be able to create answer to question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: 'Test body'
    click_on 'Create answer'

    expect(page).to have_content 'Test body'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user create answer with empty body', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: ''
    click_on 'Create answer'

    expect(page).to have_content "Body can't be blank"
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user ties to create answer to question' do
    visit question_path(question)

    expect(page).to have_no_link('Ask question')
  end
end
