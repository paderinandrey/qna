require 'rails_helper'

RSpec.shared_examples "commented" do |parameter|
  sign_in_user
  
  let(:user) { create(:user) }
  let!(:commentable) { create(parameter.underscore.to_sym, user: user) }
  
  describe 'POST #create_comment' do
    context 'with valid attributes' do
      it 'comment count change by 1' do
        expect { post :add_comment, params: { id: commentable, comment: attributes_for(:comment), format: :js } }.to change(commentable.comments, :count).by(1)
      end
      
      it 'comment belongs to user' do
        post :add_comment, params: { id: commentable, comment: attributes_for(:comment), format: :js }
        
        expect(assigns(:comment).user).to eq subject.current_user
      end
    end
    
    context 'with invalid attributes' do
      it 'with invalid attributes' do
        expect { post :add_comment, params: { id: commentable, comment: attributes_for(:invalid_comment), format: :js } }.to_not change(Comment, :count)
      end
    end
  end
end
