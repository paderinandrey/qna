require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user
  
  context "for question" do
    let(:attachable) { create(:question, user: @user) }
    it_behaves_like "attachable"
  end
    
  context "for answer" do  
    let(:attachable) { create(:answer, user: @user) }
    it_behaves_like "attachable" 
  end  
end
