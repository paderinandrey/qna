require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  
  describe "#to_builder" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question, user: user, body: 'test') }
    
    it 'Convert comment to JSON'
  end
end
