require 'rails_helper'
require 'pundit/rspec'

RSpec.describe AnswerPolicy, type: :policy do

  let!(:user) { create :user }
  let!(:answer) { create :answer }

  subject { described_class }

  context "for a guest" do
  # let(:user) { nil }
    it "123" do
      puts '-----'
      puts user.email
      puts answer.body
      puts '-----'
      expect(subject).to_not permit(user, answer)
      #should_not permit(:destroy) 
      end# expect(subject).to_not permit(:update) }
  end

  
  # permissions ".scope" do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end

  # permissions :create? do
  #   it 'grants access if user is admin' do
  #     expect(subject).to permit(User.new(admin:true), Answer.new)
  #   end
    
  #   it 'grand access if user is author' do
  #     expect(subject).to permit(user, create(:answer, user: user))
  #   end
    
  #   it 'denies access if user is not author' do
  #     expect(subject).to_not permit(User.new, Answer.new)
  #   end
  # end

  # permissions :update? do
  #   it 'grants access if user is admin' do
  #     expect(subject).to permit(User.new(admin:true), create(:answer))
  #   end
    
  #   it 'grand access if user is author' do
  #     expect(subject).to permit(user, create(:answer, user: user))
  #   end
    
  #   it 'denies access if user is not author' do
  #     expect(subject).to_not permit(User.new, create(:answer, user: user))
  #   end
  # end

  # permissions :destroy? do
  #   it 'grants access if user is admin' do
  #     expect(subject).to permit(User.new(admin:true), create(:answer))
  #   end
    
  #   it 'grand access if user is author' do
  #     expect(subject).to permit(user, create(:answer, user: user))
  #   end
    
  #   it 'denies access if user is not author' do
  #     expect(subject).to_not permit(User.new, create(:answer, user: user))
  #   end
  # end
end
