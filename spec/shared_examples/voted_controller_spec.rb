require 'rails_helper'

RSpec.shared_examples "voted" do |parameter|
    sign_in_user
    
    let(:user) { create(:user) }
    let!(:votable) { create(parameter.underscore.to_sym, user: user) }
    
    describe 'POST #like' do
      context 'alien vote' do
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
        
        context 'tries vote twice' do
          before { post :like, params: { id: votable, format: :json } }
          
          it 'doesn\'t change the number of entries in the database' do
            post :like, params: { id: votable, format: :json }
            
            expect { post :like, params: { id: votable, format: :json } }.to_not change(Vote, :count)
          end
          
          it 'total does not change' do
            post :like, params: { id: votable, format: :json }
            
            expect(votable.total).to eq 1
          end
          
          it 'vote value does not change' do
            post :like, params: { id: votable, format: :json }
            
            expect(votable.votes.last.value).to eq 1
          end
          
          # it 'show error message' do
          #   post :like, params: { id: votable, format: :json }
            
          #   expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
          # end
        end
      end
      
      context 'author' do
        before { votable.update_attributes(user: @user) }
        
        it 'doesn\'t change the number of entries in the database' do
          expect { post :like, params: { id: votable, format: :json } }.to_not change(Vote, :count)  
        end
         
        it 'total not changed' do
          post :like, params: { id: votable, format: :json }
          
          expect(votable.total).to eq 0
        end
          
        # it 'show error message' do  
        #   post :like, params: { id: votable, format: :json }
          
        #   expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
        # end  
      end
    end
    
    describe 'POST #dislike' do
      context 'alien vote' do
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
        
        context 'tries vote twice' do
          before { post :dislike, params: { id: votable, format: :json } }
          
          it 'doesn\'t change the number of entries in the database' do
            post :dislike, params: { id: votable, format: :json }
            
            expect { post :dislike, params: { id: votable, format: :json } }.to_not change(Vote, :count)
          end
          
          it 'total does not change' do
            post :dislike, params: { id: votable, format: :json }
            
            expect(votable.total).to eq -1
          end
          
          it 'vote value does not change' do
            post :dislike, params: { id: votable, format: :json }
            
            expect(votable.votes.last.value).to eq -1
          end
          
          # it 'show error message' do
          #   post :dislike, params: { id: votable, format: :json }
            
          #   expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
          # end
        end
      end
      
      context 'author vote' do
        before { votable.update_attributes(user: @user) }
        
        it 'doesn\'t change the number of entries in the database' do
          expect { post :dislike, params: { id: votable, format: :json } }.to_not change(Vote, :count)
        end
        
        it 'total not changed' do
          post :dislike, params: { id: votable, format: :json }
          
          expect(votable.total).to eq 0
        end
        
        # it 'show error message' do
        #   post :dislike, params: { id: votable, format: :json }
          
        #   expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
        # end
      end
    end
    
    describe 'PATCH #change_vote' do
      before { post :like, params: { id: votable, format: :json } } 
      
      context 'alien vote' do
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
      
      context 'author vote' do
        before do
          post :like, params: { id: votable, format: :json }
          votable.update_attributes(user: @user)  
        end
        
        it 'doesn\'t change the number of entries in the database' do
          expect { patch :change_vote, params: { id: votable, format: :json } }.to_not change(Vote, :count)
        end
        
        it 'vote value does not change' do
          patch :change_vote, params: { id: votable, format: :json }
          
          expect(votable.votes.last.value).to eq 1
        end
        
        # it 'show error message' do
        #   # patch :change_vote, params: { id: votable, format: :json }
          
        #   # expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
        # end
      end
    end
    
    describe 'DELETE #cancel_vote' do
      before { post :like, params: { id: votable, format: :json } }
      
      context 'alien vote' do
        it 'it change the number of entries in the database' do
          expect { delete :cancel_vote, params: { id: votable, format: :json } }.to change(Vote, :count).by(-1)
        end
        
        it 'total changed' do
          delete :cancel_vote, params: { id: votable, format: :json }
          
          expect(votable.total).to eq 0  
        end
      end
      
      context 'author vote' do
        before { votable.update_attributes(user: @user) }
        
        it 'it doesn\'t change the number of entries in the database' do
          expect { delete :cancel_vote, params: { id: votable, format: :json } }.to_not change(Vote, :count)
        end
        
        it 'total doen\'t changed' do
          delete :cancel_vote, params: { id: votable, format: :json }
          
          expect(votable.votes.last.value).to eq 1
        end
        
        it 'shoe error message' do
          # delete :cancel_vote, params: { id: votable, format: :json }
          
          # expect(JSON.parse(response.body)['error']).to eq "You cannot vote!"
        end
      end
    end  
end
