require_relative 'acceptance_helper'

feature 'View list of questions', %q{
  In order to get find answer
  As an user
  I want to be able to view list of question
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 10) }

  scenario 'Authenticated user view list of questions' do
    sign_in(user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
    expect(current_path).to eq questions_path
  end

  scenario 'Non-authenticated user ties to view list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
    expect(current_path).to eq questions_path
  end
end
