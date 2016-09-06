require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of :user_id }
  it { should validate_inclusion_of(:value).in_range(-1..1) }
  
  #it { should respond_to(:link).with(2).argument }
  
  #let(:user) { create(:user) }
  #let(:question) { create(:question) }
  #let(:answer) { create(:answer) }
  
  #describe '#set_evaluate' do
  #  it 'user can not vote own question' do
  #    expect { question.set_evaluate(user, 1) }.to change(question.votes, :count).by(1)
  #  end  

  #  it 'user tries overstate own vote' do
  #    expect { question.set_evaluate(user, 2) }.to_not change(Vote, :count)
  #  end
  #end
end

