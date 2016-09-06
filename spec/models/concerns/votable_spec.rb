require 'rails_helper'

RSpec.shared_examples_for "votable" do
  let(:model) { described_class }
  let(:user) { create(:user) }
  
  before { @votable = create(model.to_s.underscore.to_sym) } 
  
  describe '#set_evaluate' do
    it ':like' do
      expect { @votable.set_evaluate(user, 1) }.to change(@votable.votes, :count).by(1)
    end
    
    it ':dislike' do
      expect { @votable.set_evaluate(user, -1) }.to change(@votable.votes, :count).by(1)
    end
    
    it 'overrate' do
      expect { @votable.set_evaluate(user, 2) }.to_not change(Vote, :count)
    end
  end
  
  it '#change_evaluate' do
    @votable.set_evaluate(user, 1)
    @votable.change_evaluate(user)
    
    expect(@votable.votes.last.value).to eq(-1)
  end
  
  it '#cancel_evaluate' do
    @votable.set_evaluate(user, 1)
    
    expect { @votable.cancel_evaluate(user) }.to change(Vote, :count).by(-1)
  end
  
  it '#user_voted?' do
    expect(@votable.user_voted?(user)).to be false
    
    @votable.set_evaluate(user, 1)
    
    expect(@votable.user_voted?(user)).to be true
  end
  
  it '#user_can_vote?' do
    expect(@votable.user_can_vote?(user)).to be true
    
    @votable.update_attribute(:user, user)
    
    expect(@votable.user_can_vote?(user)).to be false
  end
  
  it '#like_by?' do
    @votable.set_evaluate(user, 1)
    
    expect(@votable.like_by?(user)).to be true
    
    @votable.change_evaluate(user)
    
    expect(@votable.like_by?(user)).to be false
    
    @votable.cancel_evaluate(user)
    
    expect(@votable.like_by?(user)).to be false
  end
  
  it '#total' do
    @votable.set_evaluate(user, 1)
    
    expect(@votable.total).to eq 1
    
    @votable.change_evaluate(user)
    
    expect(@votable.total).to eq(-1)
    
    @votable.cancel_evaluate(user)
    
    expect(@votable.total).to eq 0
    
    @votable.set_evaluate(user, -1)
    
    expect(@votable.total).to eq(-1)
    
    @votable.change_evaluate(user)
    
    expect(@votable.total).to eq 1
  end
end