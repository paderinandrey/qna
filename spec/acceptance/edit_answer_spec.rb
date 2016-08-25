require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I would like to be able to edit my answer
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:alien_user) { create(:user) }
  given!(:alien_answer) { create(:answer, question: question, user: alien_user) }
  
  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    
    within('.answers') do
      expect(page).to have_no_link 'Edit'
    end  
  end
  
  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'try to edit his answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'answer_body', with: 'edited answer'
        click_on 'Save'
        
        expect(page).to have_no_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_no_selector 'textarea'
      end
    end
    
    scenario 'try to edit other answer' do
      within "#answer-#{alien_answer.id}" do
        expect(page).to have_no_link 'Edit'
      end
    end
  end
end
