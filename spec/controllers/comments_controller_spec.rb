require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user

  let!(:question) { create(:question) }
  let!(:comment) { create(:comment, commentable: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'comment count change by 1' do
        expect { post :create, params: { commentable_type: 'question', comment: attributes_for(:comment), question_id: question.id, format: :json } }.to change(question.comments, :count).by(1)
      end
      
      it 'comment belongs to user' do
        post :create, params: { commentable_type: 'question', comment: attributes_for(:comment), question_id: question.id, format: :json }
        
        expect(assigns(:comment).user).to eq subject.current_user
      end
      
      context 'publish_to' do
        it 'invokes publish_to for PrivatePub' do
          expect(PrivatePub).to receive(:publish_to)
          
          post :create, params: { commentable_type: 'question', comment: attributes_for(:comment), question_id: question.id, format: :json }
        end
        
        it 'publish to PrivatePub' do
          new_comment = create(:comment, commentable: question)
          allow(Comment).to receive(:new).and_return(new_comment)
          expect(PrivatePub).to receive(:publish_to) do |channel, data|
            expect(channel).to eq "/questions/#{ question.id }/comments"
            %w(id body).each do |attr|
              expect(data[:comment]).to be_json_eql(new_comment.send(attr.to_sym).to_json).at_path("#{attr}")
            end  
          end
          post :create, params: { commentable_type: 'question', comment: attributes_for(:comment), question_id: question.id, format: :json }
        end
      end
    end
    
    context 'with invalid attributes' do
      it 'with invalid attributes' do
        expect { post :create, params: { commentable_type: 'question', comment: attributes_for(:invalid_comment), question_id: question.id, format: :json } }.to_not change(Comment, :count)
      end
      
      context 'publish_to' do
        it 'doesn\'t publish to PrivatePub' do
          expect(PrivatePub).to_not receive(:publish_to)
          
          post :create, params: { commentable_type: 'question', comment: attributes_for(:invalid_comment), question_id: question.id, format: :json }
        end
      end
    end
  end

  describe 'PATCH #update' do
    
    before { comment.update_attribute(:user, @user) }
    
    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: comment, comment: attributes_for(:comment), format: :json }
      
      expect(assigns(:comment)).to eq comment
    end
    
    it 'changes answer attributes' do
      patch :update, params: { id: comment, comment: { body: 'new body' }, format: :json }
      comment.reload
      
      expect(comment.body).to eq 'new body'
    end
    
    it 'render update template' do
      patch :update, params: { id: comment, comment: attributes_for(:comment), format: :js }
      
      expect(response).to render_template :update
    end
    
    context 'publish_to' do
      it 'invokes publish_to for PrivatePub' do
        expect(PrivatePub).to receive(:publish_to)
        
        patch :update, params: { id: comment, comment: attributes_for(:comment), format: :js }
      end
      
      it 'publish to PrivatePub' do
        new_comment = create(:comment, commentable: question, user: @user)
        allow(Comment).to receive(:update).and_return(new_comment)
        expect(PrivatePub).to receive(:publish_to) do |channel, data|
          expect(channel).to eq "/questions/#{ question.id }/comments"
          expect(data[:comment]).to be_json_eql(new_comment.send(:id).to_json).at_path('id')
        end
        patch :update, params: { id: new_comment, comment: attributes_for(:comment), format: :js }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, commentable: question, user: @user) }

    it 'deletes comment' do
      expect { delete :destroy, params: { id: comment, format: :json } }.to change(Comment, :count).by(-1)
    end

    it 'render destroy view' do
      delete :destroy, params: { id: comment, format: :js }
      
      expect(response).to render_template :destroy
    end
    
    context 'publish_to' do
      it 'invokes publish_to for PrivatePub' do
        expect(PrivatePub).to receive(:publish_to)
        
        delete :destroy, params: { id: comment, format: :json }
      end
      
      it 'publish to PrivatePub' do
        new_comment = create(:comment, commentable: question, user: @user)
        allow(Comment).to receive(:destroy).and_return(new_comment)
        expect(PrivatePub).to receive(:publish_to) do |channel, data|
          expect(channel).to eq "/questions/#{ question.id }/comments"
          expect(data[:comment]).to be_json_eql(new_comment.send(:id).to_json).at_path('id')
        end
        delete :destroy, params: { id: new_comment, format: :json }
      end
    end
  end
end
