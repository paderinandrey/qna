require 'rails_helper'

feature 'Read answers of question', %q{
  In order to get answer
  As an user
  I want to be able to read questions and answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 10, question: question) }

  scenario 'Authenticated user read answers of question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user to read answers of question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
    expect(current_path).to eq question_path(question)
  end
end
