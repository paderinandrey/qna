require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  
  it_behaves_like 'votable'
  
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  
  it { accept_nested_attributes_for :attachments }
  
  describe '#create_subscription_for_author' do
    let(:question) { build(:question) }
    
    it 'create subscription for author' do
      expect(question).to receive(:create_subscription_for_author).and_call_original
      question.save
    end  
  end
end
