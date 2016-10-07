require 'rails_helper'

RSpec.describe User, type: :model do
  
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

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
  
  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    context 'User already has authentication' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook')
      end
    end
    
    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email } ) }
        
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end
        
        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end
        
        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
        
        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
      
      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }
        
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count)
        end
        
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end
        
        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
        
        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe "#username" do
    let(:user) { create(:user) }
    let(:named_user) { create(:named_user) }

    it 'user hasn\'t name' do
      expect(user.username).to eq user.email
    end
    
    it 'user has name' do
      expect(named_user.username).to eq named_user.name
    end
  end
  
  describe ".generate" do
    it 'with invalid params' do
      invalid_params = {email: ''}
      
      expect(User.generate(invalid_params)).to_not be_valid
    end
    
    it 'with valid params' do
      valid_params = {email: 'test1@test.com'}
      
      expect(User.generate(valid_params)).to be_valid
    end
  end
  
  describe '#has_subscribed?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    
    it 'User not subscribe to question' do
      expect(user.has_subscribed?(question)).to eq false
    end
    
    it 'User subscribe to question' do
      user.subscribe_to(question)
      expect(user.has_subscribed?(question)).to eq true
    end
  end
  
  describe '#subscribe_to' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    
    it 'creates new subscription for user' do
      expect { user.subscribe_to(question) }.to change(question.subscriptions, :count).by(1)
    end
    
    it 'subscription belongs to user' do
      subscription = user.subscribe_to(question)
      
      expect(subscription.user).to eq user
    end
  end
  
  describe '#unsubscribe_from' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question: question) }
    
    it 'deletes subscription from user' do
      expect { user.unsubscribe_from(question) }.to change(Subscription, :count).by(-1)
    end
  end
end
