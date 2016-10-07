require_relative '../acceptance_helper'

feature 'Subscribe to question', %q{
  In order to choose the receive timely alerts about change own question 
  As an user
  I want to be able to subscribe own question
} do
  let(:user) { create(:user) }
  let(:alien) { create(:user) }
  let(:question) { create(:question, user: user) }
    
  describe 'Author of question' do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Unsubscribe'
    end
    
    scenario 'sees subscribe link', js: true do 
      expect(page).to have_link 'Subscribe'
    end
    
    scenario 'tries to subscribe to the question', js: true do 
      click_on 'Subscribe'
      
      expect(page).to have_link 'Unsubscribe'
    end
  end
  
  describe 'Authenticated user' do
    background do
      sign_in(alien)
      visit question_path(question)
      click_on 'Subscribe'
    end
    
    scenario 'sees unsubscribe link', js: true do 
      expect(page).to have_link 'Unsubscribe'
    end
    
    scenario 'tries to unsubscribe to the question', js: true do 
      click_on 'Unsubscribe'
      
      expect(page).to have_link 'Subscribe'
    end
  end
  
  describe 'Non-authenticated user' do
    scenario 'tries to subscribe to the question' do
      visit question_path(question)
      
      expect(page).to have_no_link 'Subscribe'
      expect(page).to have_no_link 'Unsubscribe'
    end
  end
end
