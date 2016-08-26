require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able attach files
} do
  
  given(:user) { create(:user) }
  
  background do
    
  end
end
