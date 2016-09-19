require_relative '../acceptance_helper'

feature 'Voting for answers', %q{
  In order to choose the favorite answer from all 
  As an user
  I want to be able to voite for answer
} do
  
  given(:user) { create(:user) }
  given(:alien_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  
  describe "User vote" do
  
    background do
      sign_in(alien_user)
      visit question_path(question)
    end
      
    scenario 'set a positive evaluation for answer', js: true do
      within ".vote-for-answer" do
        click_link('like')
      end
    
      within ".result-vote-for-answer" do
        expect(page).to have_content '1'
      end
      
      within ".vote-for-answer" do
        expect(page).to have_css '.fa.fa-thumbs-up'
      end
    end
    
    scenario 'set a negative evaluation for answer', js: true do
      within ".vote-for-answer" do
        click_link('dislike')
      end
    
      within '.result-vote-for-answer' do
        expect(page).to have_content '-1'
      end
      within ".vote-for-answer" do
        expect(page).to have_css '.fa.fa-thumbs-down'
      end
    end
    
    scenario 'change its evaluation for answer', js: true do
      within ".vote-for-answer" do
        click_link('like')
        click_link('change_vote')
      end
      
      within ".result-vote-for-answer" do
        expect(page).to have_content '-1'
      end
      
      within ".vote-for-answer" do
        expect(page).to have_css '.fa.fa-thumbs-down'
        expect(page).to have_css '.fa.fa-thumbs-o-up'
      end
    end
    
    describe 'cancel its evaluation for answer' do 
      scenario 'for like', js: true do
        within ".vote-for-answer" do
          click_link('like')
          click_link('cancel_vote')
        end
        
        within '.vote-for-answer' do
          expect(page).to have_content '0'
        end
      end
      
      scenario 'for dislike', js: true do
        within ".vote-for-answer" do
          click_link('dislike')
          click_link('cancel_vote')
        end
        
        within '.vote-for-answer' do
          expect(page).to have_content '0'
        end
      end
    end
  end

  describe 'Author of answer' do
    scenario 'tries set a evaluation for answer', js: true do
      sign_in(user)
      visit question_path(question)
      
      expect(page).to have_css '.result-vote-for-answer'
      expect(page).to have_no_link 'like'
      expect(page).to have_no_link 'dislike'
    end
  end
  
  describe 'Non-authenticated user ' do
    scenario 'tries set a evaluation for answer' do
      visit question_path(question)
      
      expect(page).to have_css '.result-vote-for-answer'
      expect(page).to have_no_link 'like'
      expect(page).to have_no_link 'dislike'
    end  
  end
end
