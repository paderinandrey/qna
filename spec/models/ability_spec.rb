require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  
  describe 'for guest' do
    let(:user) { nil }
    
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }
    it { should be_able_to :read, Vote }
    
    it { should be_able_to :confirm_email, User }
    
    it { should_not be_able_to :manage, :all }
  end
  
  describe 'for admin' do
    let(:user) { create :user, admin: true }
    
    it { should be_able_to :manage, :all }
  end
  
  describe 'for user' do
    let(:user) { create :user }
    let(:alien) { create :user }
    
    let(:user_question) { create(:question, user: user) }
    let(:alien_question) { create(:question, user: alien) }
    
    let(:user_answer) { create(:answer, user: user) }
    let(:alien_answer) { create(:answer, user: alien) }
    
    let(:user_comment) { create(:comment, commentable: alien_question, user: user) }
    let(:alien_comment) { create(:comment, commentable: user_question, user: alien) }
    
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    
    context 'creating' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create, Attachment }
    end
    
    context 'updating' do
      it { should be_able_to :update, user_question, user: user }
      it { should_not be_able_to :update, alien_question, user: user }
      
      it { should be_able_to :update, user_answer, user: user }
      it { should_not be_able_to :update, alien_answer, user: user }
      
      it { should be_able_to :update, user_comment, user: user }
      it { should_not be_able_to :update, alien_comment, user: user }
    end
    
    context 'destroying' do
      it { should be_able_to :destroy, user_question, user: user }
      it { should_not be_able_to :destroy, alien_question, user: user }
      
      it { should be_able_to :destroy, user_answer, user: user }
      it { should_not be_able_to :destroy, alien_answer, user: user }
      
      it { should be_able_to :destroy, user_comment, user: user }
      it { should_not be_able_to :destroy, alien_comment, user: user }
      
      it { should be_able_to :destroy, create(:attachment, attachable: user_question), user: user }
      it { should_not be_able_to :destroy, create(:attachment, attachable: alien_question), user: user }
    end
    
    context 'best' do
      it { should be_able_to :best, create(:answer, question: user_question), user: user }
      it { should_not be_able_to :best, create(:answer, question: alien_question), user: user }
    end
    
    let(:user_subject) { user_question }
    let(:alien_subject) { alien_question }
    it_behaves_like "Right to vote"
    
    let(:user_subject) { user_answer }
    let(:alien_subject) { alien_answer }
    it_behaves_like "Right to vote"
    
    context 'profile' do
      it { should be_able_to :me, User }
      it { should be_able_to :index, User.everyone_but_me(user) }
    end
    
    context 'subscriptions' do
      it { should be_able_to :subscribe, Question }
      it { should be_able_to :unsubscribe, Question, user: user }
    end
  end
end
