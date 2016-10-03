require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user

  let!(:question) { create(:question) }
  let!(:comment) { create(:comment, commentable: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'comment count change by 1' do
        expect { post :create, params: { commentable_type: 'question', comment: attributes_for(:comment), question_id: question.id, format: :js } }.to change(question.comments, :count).by(1)
      end
      
      it 'comment belongs to user' do
        post :create, params: { commentable_type: 'question', comment: attributes_for(:comment), question_id: question.id, format: :js }
        
        expect(assigns(:comment).user).to eq subject.current_user
      end
    end
    
    context 'with invalid attributes' do
      it 'with invalid attributes' do
        expect { post :create, params: { commentable_type: 'question', comment: attributes_for(:invalid_comment), question_id: question.id, format: :js } }.to_not change(Comment, :count)
      end
    end
  end

  describe 'PATCH #update' do
    
    before { comment.update_attribute(:user, @user) }
    
    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: comment, comment: attributes_for(:comment), format: :js }
      expect(assigns(:comment)).to eq comment
    end
    
    it 'changes answer attributes' do
      patch :update, params: { id: comment, comment: { body: 'new body' }, format: :js }
      comment.reload
      expect(comment.body).to eq 'new body'
    end
    
    it 'render update template' do
      patch :update, params: { id: comment, comment: attributes_for(:comment), format: :js }
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, commentable: question, user: @user) }

    it 'deletes comment' do
      expect { delete :destroy, params: { id: comment, format: :js } }.to change(Comment, :count).by(-1)
    end

    it 'render destroy view' do
      delete :destroy, params: { id: comment, format: :js }
      expect(response).to render_template :destroy
    end
  end
end
