require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  
  let(:question) { create :question }
  let(:answer) { create(:answer, question_id: question.id) }
  
  describe 'POST #create' do
    
    context 'with valid attributes' do
      it 'saves new answer in the db' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end
      
      it 'redner show question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    
    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end
      
      it 'render create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end
  
  describe 'PATCH #update' do
  end
  
  describe 'DELETE #destroy' do
    before { answer }
    
    it 'deletes answer' do
      expect { delete :destroy, params: { id: answer.id, question_id: question } }.to change(question.answers, :count).by(-1)
    end
    
    it 'render question show template' do
      delete :destroy, params: { id: answer.id, question_id: question }
      expect(response).to redirect_to question_path(question)
    end
  end
end
