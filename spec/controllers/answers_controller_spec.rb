require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  
  describe 'POST #create' do
    let(:question) { create :question }
    
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
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
  
  describe 'PATCH #update' do
  end
  
  describe 'DELETE #destroy' do
  end
end
