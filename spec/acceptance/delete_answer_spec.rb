require 'rails_helper'

feature 'Delete answers', %q{
  In order to get find answer
  As an authenticated user
  I want to be able to delete answers
} do
    
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 10, question: question) }
  
  scenario 'Authenticated user can delete answers of question' do
    sign_in(user)
    visit question_path(question)
    within('.answers') do
      answers.each do |answer|
        click_link('delete', href: question_answer_path(id: answer, question_id: question))
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
        click_link('delete', href: question_answer_path(id: answer, question_id: question))
      end
    end  
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end