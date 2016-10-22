require_relative '../acceptance_helper'

feature 'Delete answers', %q{
  In order to get ???
  As an authenticated user
  I want to be able to delete answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:alien_user) { create(:user) }
  given!(:alien_answer) { create(:answer, question: question, user: alien_user) }

  scenario 'Authenticated user can delete answers of question', js: true  do
    sign_in(user)
    visit question_path(question)
    within('.answers') do
      click_link('Delete', href: answer_path(answer))
    end
    # Selenium
    #a = page.driver.browser.switch_to.alert
    #expect(a.text).to eq("Are you sure you want to delete this answer?")
    #a.accept
    # Webkit
    #page.accept_confirm do
    #  click_link "Delete"
    #end
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_no_content answer.body
    expect(current_path).to eq question_path(question)
  end
  
  scenario 'Authenticated user sees link to Delete' do
    sign_in(user)
    visit question_path(question)
    
    within('.answers') do
      expect(page).to have_link("Delete", href: answer_path(answer))
      expect(page).to have_xpath "//a[@href='#{answer_path(answer)}'][@data-method='delete']"
    end
  end
  
  scenario 'Non-authenticated user can not delete answer' do
    visit question_path(question)

    within('.answers') do
      expect(page).to have_no_link("Delete", href: answer_path(answer))
      expect(page).to have_no_xpath "//a[@href='#{answer_path(answer)}'][@data-method='delete']"
    end
  end

  scenario 'Alien user can not delete answer', js: true  do
    sign_in(user)

    visit question_path(question)

    within('.answers') do
      expect(page).to have_no_link("Delete", href: answer_path(alien_answer))
      expect(page).to have_no_xpath "//a[@href='#{answer_path(alien_answer)}'][@data-method='delete']"
    end
  end
end
