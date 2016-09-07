require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  
  #it { should respond_to(:author_of?).with(1).argument }
  let!(:user) { create(:user) }
  let(:alien) { create(:user) }
  let!(:question) { create(:question, user: user) }
  
  it '#author_of?' do
    expect(alien.author_of?(question)).to be false
    expect(user.author_of?(question)).to be true
  end
  
  it '#can_vote?' do
    question.set_evaluate(user, 1)
    
    expect(user.can_vote?(question)).to be false
    expect(alien.can_vote?(question)).to be true
  end
    
  it '#voted?' do
    expect(user.voted?(question)).to be false
    
    question.set_evaluate(user, 1)
    
    expect(user.voted?(question)).to be true
  end
  
  it '#like?' do
    question.set_evaluate(user, 1)
    
    expect(user.like?(question)).to be true
    
    question.change_evaluate(user)
    
    expect(user.like?(question)).to be false
    
    question.set_evaluate(user, -1)
    
    expect(user.like?(question)).to be false
    
    question.cancel_evaluate(user)
    
    expect(user.like?(question)).to be false
  end
end
