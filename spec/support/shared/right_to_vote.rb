shared_examples_for "Right to vote" do
  describe 'voting' do
    it { should be_able_to :like, alien_subject, user: user }
    it { should_not be_able_to :like, user_subject, user: user }
    
    it { should be_able_to :dislike, alien_subject, user: user }
    it { should_not be_able_to :dislike, user_subject, user: user }
    
    context 'change vote' do
      before { alien_subject.set_evaluate(user, 1) }
      it { should be_able_to :change_vote, alien_subject, user: user }
      it { should_not be_able_to :change_vote, user_subject, user: user }
    end
    
    context 'cancel vote' do
      before { alien_subject.set_evaluate(user, 1) }
      it { should be_able_to :cancel_vote, alien_subject, user: user } 
      it { should_not be_able_to :cancel_vote, user_subject, user: user }
    end
  end
end
