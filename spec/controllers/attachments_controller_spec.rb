require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:question_file) { create(:attachment, attachable: question) }
  
  sign_in_user
  
  describe 'DELETE #destroy' do
    describe 'Questions' do
      context 'Alien user' do
        it 'tries to delete question files' do
          expect { delete :destroy, params: { id: question_file, format: :js } }.not_to change(Attachment, :count)
        end
        
        it 'render destoy view' do
          delete :destroy, params: { id: question_file, format: :js }
          
          expect(response).to render_template :destroy
        end
      end
      
      context 'Author of question' do
        before { question.update_attribute(:user, @user) }
        
        it 'deletes files' do
          expect { delete :destroy, params: { id: question_file, format: :js } }.to change(Attachment, :count).by(-1)
        end
        
        it 'render destroy view' do
          delete :destroy, params: { id: question_file, format: :js }
          
          expect(response).to render_template :destroy
        end
      end
    end  
    
    describe 'Answers' do
      let(:answer) { create(:answer, question: question, user: user) }
      let!(:answer_file) { create(:attachment, attachable: answer) }
      
      context 'Alien user' do
        it 'tries to delete answer files' do
          expect { delete :destroy, params: { id: answer_file, format: :js } }.not_to change(Attachment, :count)
        end
        
        it 'render destoy view' do
          delete :destroy, params: { id: answer_file, format: :js }
          
          expect(response).to render_template :destroy
        end
      end
      
      context 'Author of answer' do
        before { answer.update_attribute(:user, @user) }
        it 'deletes files' do
          expect { delete :destroy, params: { id: answer_file, format: :js } }.to change(Attachment, :count).by(-1)
        end
        
        it 'render destroy view' do
          delete :destroy, params: { id: answer_file, format: :js }
          
          expect(response).to render_template :destroy
        end
      end
    end  
  end
end
