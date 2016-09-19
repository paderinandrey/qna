require_relative '../acceptance_helper'

feature 'Delete files from question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able delete files
} do
  
  given(:user) { create(:user) }
  given(:alien_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:file) { create(:attachment, attachable: question) }
  
  scenario 'User deletes file from question', js: true do
    sign_in(user)
    visit question_path(question)
    
    expect(page).to have_link(file.file.filename) 
    
    within "#files-for-question-#{ question.id }" do
      click_on 'Delete'
    end  
    
    expect(page).to have_no_link(file.file.filename)
  end
  
  scenario 'Alien user try to delete files from question', js: true do
    sign_in(alien_user)
    visit question_path(question)
    
    within "#files-for-question-#{ question.id }" do
      expect(page).to have_no_link("Delete", href: attachment_path(file))
      expect(page).to have_no_xpath "//a[@href='#{attachment_path(file)}'][@data-method='delete']"
    end  
  end
  
  scenario 'Non-authenticated user ties to delete files from question', js: true do
    visit question_path(question)
    
    expect(page).to have_no_link("Delete", href: attachment_path(file))
    expect(page).to have_no_xpath "//a[@href='#{attachment_path(file)}'][@data-method='delete']"
  end
end
