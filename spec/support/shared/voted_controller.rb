shared_examples_for "voted" do |parameter|
  sign_in_user
  
  let(:user) { create(:user) }
  let!(:votable) { create(parameter, user: user) }
  
  describe 'POST #like' do
    it 'vote count change by 1' do
      expect { post :like, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
    end
    
    it 'vote value change by 1' do
      post :like, params: { id: votable, format: :json }
      
      expect(votable.votes.last.value).to eq 1
    end
    
    it 'total change by 1' do
      post :like, params: { id: votable, format: :json }
      
      expect(votable.votes.last.value).to eq 1
    end
  end
  
  describe 'POST #dislike' do
    it 'vote count change by 1' do
      expect { post :dislike, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
    end
      
    it 'vote value change by 1' do
      post :dislike, params: { id: votable, format: :json }
       
      expect(votable.votes.last.value).to eq -1
    end 
    
    it 'total change by 1' do
      post :dislike, params: { id: votable, format: :json }
      
      expect(votable.total).to eq -1
    end
  end
  
  describe 'PATCH #change_vote' do
    before { post :like, params: { id: votable, format: :json } } 
    
    it 'change the number of entries in the database' do
      expect { patch :change_vote, params: { id: votable, format: :json } }.to_not change(votable.votes, :count)
    end
    
    it 'vote value changed' do
      patch :change_vote, params: { id: votable, format: :json }
      votable.reload
      expect(votable.votes.last.value).to eq -1
    end
    
    it 'total changed' do
      
      patch :change_vote, params: { id: votable, format: :json }
      votable.reload
      expect(votable.total).to eq -1
    end
  end
  
  describe 'DELETE #cancel_vote' do
    before { post :like, params: { id: votable, format: :json } }
    
    it 'it change the number of entries in the database' do
      expect { delete :cancel_vote, params: { id: votable, format: :json } }.to change(Vote, :count).by(-1)
    end
    
    it 'total changed' do
      delete :cancel_vote, params: { id: votable, format: :json }
      
      expect(votable.total).to eq 0  
    end
  end
end
