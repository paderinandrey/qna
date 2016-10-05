require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }
  it { should validate_inclusion_of(:commentable_type).in_array(['Question', 'Answer']) }
  
  describe "#question_id" do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    
    let(:comment_for_question) { create(:comment, commentable: question) }
    let(:comment_for_answer) { create(:comment, commentable: answer) }
    
    it 'return id if Question' do
      expect(comment_for_question.question_id).to eq question.id
    end
    
    it 'return question_id if Answer' do
      expect(comment_for_answer.question_id).to eq answer.question_id
    end
  end
end
