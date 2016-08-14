require 'rails_helper'

feature 'Delete answers', %q{
  In order to get find answer
  As an authenticated user
  I want to be able to delete answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }
  given(:alien_user) { create(:user) }
  given!(:alien_answers) { create_list(:answer, 3, question: question, user: alien_user) }

  scenario 'Authenticated user can delete answers of question' do
    sign_in(user)

    visit question_path(question)
    within('.answers') do
      answers.each do |answer|
        click_link('Delete', href: question_answer_path(id: answer, question_id: question))
      end
    end

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    within('.answers') do
      answers.each do |answer|
        expect(page).to have_no_content answer.body
      end
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user can not delete answer' do
    visit question_path(question)

    within('.answers') do
      answers.each do |answer|
        expect(page).to have_no_link("Delete", href: question_answer_path(id: answer, question_id: question))
        expect(page).to have_no_xpath "//a[@href='#{question_answer_path(id: answer, question_id: question)}'][@data-method='delete']"
      end
    end
  end

  scenario 'Alien user can not delete answer' do
    sign_in(user)

    visit question_path(question)

    within('.answers') do
      alien_answers.each do |answer|
        expect(page).to have_no_link("Delete", href: question_answer_path(id: alien_answers, question_id: question))
        expect(page).to have_no_xpath "//a[@href='#{question_answer_path(id: alien_answers, question_id: question)}'][@data-method='delete']"
      end
    end
  end
end
