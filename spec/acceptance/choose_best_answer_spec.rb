require_relative 'acceptance_helper'

feature 'Choose the best answer', %q{
  In order to help others
  As an author of question
  I want to be able to choose the best answer for my question
} do
  
  given(:user) { create(:user) }
  given!(:alien_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: alien_user) }
  given!(:answer2) { create(:answer, question: question, user: alien_user) }
  
  scenario 'Unauthenticated user try set the best answer' do
    visit question_path(question)
    
    within('.answers') do
      expect(page).to have_no_link 'Best answer'
    end
  end
  
  scenario 'Author of question can choose the best answer (and only one)', js: true do
    sign_in(user)
    visit question_path(question)
    within("#answer-#{answer2.id}") do
      click_on 'Best answer'
    end
    
    within('.answers') do
      expect(page).to have_css('.best-answer', count: 1)
      expect(page).to have_css("li#answer-#{answer2.id}.best-answer")
    end
  end
  
  scenario 'Author of question can cancel the best answer', js: true do
    sign_in(user)
    answer2.update_attributes(best: true)
    visit question_path(question)
    within("#answer-#{answer2.id}") do
      click_on 'Not best answer'
    end
    
    within('.answers') do
      expect(page).to have_css('.best-answer', count: 0)
      expect(page).to have_no_css("li#answer-#{answer2.id}.best-answer")
    end  
  end
  
  scenario 'Author of question can change the best answer', js: true do
    sign_in(user)
    answer2.update_attributes(best: true)
    visit question_path(question)
    within("#answer-#{answer1.id}") do
      click_on 'Best answer'
    end

    within('.answers') do
      expect(page).to have_css('.best-answer', count: 1)
      expect(page).to have_no_css("li#answer-#{answer2.id}.best-answer")
      expect(page).to have_css("li#answer-#{answer1.id}.best-answer")
    end
  end
  
  scenario 'Any other user try set the best answer' do
    sign_in(alien_user)
    visit question_path(question)
  
    within('.answers') do
      expect(page).to have_no_link 'Best answer'
    end
  end
end
