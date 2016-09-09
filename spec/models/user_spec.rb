require 'rails_helper'

RSpec.describe User, type: :model do
  
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  
  let!(:user) { create(:user) }
  let(:alien) { create(:user) }
  let!(:question) { create(:question, user: user) }
  
  describe "#author_of?" do
    it 'User is a author of question' do
      expect(user).to be_author_of(question)
    end
    
    it 'Alien isn\'t a author of question' do
      expect(alien).to_not be_author_of(question)
    end
  end
  
  describe "#can_vote?" do
    before { question.set_evaluate(user, 1) }
    it 'User can\'t vote own question' do
      expect(user).to_not be_can_vote(question)
    end
    
    it 'Alien can vote question' do
      expect(alien).to be_can_vote(question)
    end
  end
  
  describe "#voted?" do
    it 'User voted' do
      question.set_evaluate(user, 1)
      
      expect(user).to be_voted(question)
    end
    
    it 'Alien didn\'t vote' do
      expect(alien).to_not be_voted(question)
    end
  end
  
  describe "#like?" do
    it 'User set [like]' do
      question.set_evaluate(user, 1)
      
      expect(user).to be_like(question)
    end
      
    it 'User set another evaluate' do
      question.set_evaluate(user, -1)
      
      expect(user).to_not be_like(question)
    end
  end
end
