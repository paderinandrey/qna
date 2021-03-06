require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able attach files
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  background do
    sign_in(user)
    visit question_path(question)
  end
  
  scenario 'Users adds file when asks answer', js: true do
    fill_in 'answer_body', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'
    
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
