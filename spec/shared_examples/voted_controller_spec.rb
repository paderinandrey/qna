require 'rails_helper'

RSpec.shared_examples "voted" do |parameter|
    sign_in_user
    
    let(:user) { create(:user) }
    let(:votable) { create(parameter.underscore.to_sym, user: user) }
    
    describe 'POST #like' do
      it 'alien vote' do
        expect { post :like, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
        expect(votable.total).to eq 1
        expect(votable.votes.last.value).to eq 1
      end
      
      it 'tries vote twice' do
        post :like, params: { id: votable, format: :json }
        expect { post :like, params: { id: votable, format: :json } }.to_not change(Vote, :count)
        expect(votable.total).to eq 1
        expect(votable.votes.last.value).to eq 1
        expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
      end
      
      it 'author vote' do
        votable.update_attributes(user: @user)
        
        expect { post :like, params: { id: votable, format: :json } }.to_not change(Vote, :count)
        expect(votable.total).to eq 0
        expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
      end
    end
    
    describe 'POST #dislike' do
      it 'alien vote' do
        expect { post :dislike, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
        expect(votable.votes.last.value).to eq -1
        expect(votable.total).to eq -1
      end
      
      it 'tries vote twice' do
        post :dislike, params: { id: votable, format: :json }
        expect { post :dislike, params: { id: votable, format: :json } }.to_not change(Vote, :count)
        expect(votable.total).to eq -1
        expect(votable.votes.last.value).to eq -1
        expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
      end
      
      it 'author vote' do
        votable.update_attributes(user: @user)
        
        expect { post :dislike, params: { id: votable, format: :json } }.to_not change(Vote, :count)
        expect(votable.total).to eq 0
        expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
      end
    end
    
    describe 'PATCH #change_vote' do
      it 'alien vote' do
        post :like, params: { id: votable, format: :json } 
        
        expect { patch :change_vote, params: { id: votable, format: :json } }.to_not change(votable.votes, :count)
        expect(votable.votes.last.value).to eq -1
        expect(votable.total).to eq -1
      end
      
      it 'author vote' do
        post :like, params: { id: votable, format: :json }
        votable.update_attributes(user: @user)
        
        expect { patch :change_vote, params: { id: votable, format: :json } }.to_not change(Vote, :count)
        expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
      end
    end
    
    describe 'DELETE #cancel_vote' do
      it 'alien vote' do
        post :like, params: { id: votable, format: :json } 
        
        expect { delete :cancel_vote, params: { id: votable, format: :json } }.to change(Vote, :count).by(-1)
        expect(votable.total).to eq 0
      end
      
      it 'author vote' do
        post :like, params: { id: votable, format: :json }
        votable.update_attributes(user: @user)
        
        expect { delete :cancel_vote, params: { id: votable, format: :json } }.to_not change(Vote, :count)
        expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
      end
    end  
end
