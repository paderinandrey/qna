require_relative '../acceptance_helper'

feature 'Editing comment to answer', %q{
  In order to fix mistake
  As an author of answer
  I would like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:alien) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:comment) { create(:comment, commentable: answer, user: user) }

  scenario 'Author edit own comment to answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answer-comment' do
      click_on('Edit comment')
      fill_in 'comment_body', with: 'new test comment'
      click_on('Save comment')
    end
    
    expect(page).to have_content 'new test comment'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Alien tries to edit comment to answer' do
    sign_in(alien)
    visit question_path(question)
    
    within '.answer-comment' do
      expect(page).to have_no_link('Edit comment')
    end 
  end

  scenario 'Non-authenticated user tries to edit comment to answer' do
    visit question_path(question)
    
    within '.answer-comment' do
      expect(page).to have_no_link('Edit comment')
    end
  end
end
