require_relative 'acceptance_thinking_sphinx_helper'

feature 'Users can locate content by searching for', %q{
  In order to be able to find questions interested for me
  As an non-registered user
  I want to be able to search questions
} do

  given(:user) { create(:user) }
  given!(:find_me) { create(:question, body: 'blablabla', user: user) }
  given!(:questions) { create_list(:question, 2,  user: user) }

  before do
    ThinkingSphinx::Test.index
  end

  scenario 'Non-registered user try to search' do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'q', with: 'blablabla'
      select('Question', from: 'a')
      click_on 'search_button'
  
      expect(page).to have_content find_me.body
      expect(current_path).to eq search_path
    end
  end
end
