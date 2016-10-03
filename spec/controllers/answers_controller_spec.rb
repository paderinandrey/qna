require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user

  let!(:question) { create :question }
  let!(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saves new answer in the db' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'answer belongs to user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(assigns(:answer).user).to eq subject.current_user
      end

      it 'redner show question template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end
    
    it 'changes answer attributes' do
      patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
      answer.reload
      expect(answer.body).to eq 'new body'
    end
    
    it 'render update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

  describe 'PATCH #best' do
    let(:alien_user) { create(:user) }
    let!(:not_best_answer) { create(:answer, question: question, user: alien_user, best: false) }
    
    context 'Author of question' do
      before do
        question.update_attribute(:user, @user)
        patch :best, params: { id: not_best_answer, format: :js }
        not_best_answer.reload
      end  

      it 'assigns the requested answer_id to @answer' do
        expect(assigns(:answer)).to eq not_best_answer
      end
      
      it 'set the best answer' do
        expect(not_best_answer.best).to eq true
      end
      
      it 'cancel best answer' do
        patch :best, params: { id: not_best_answer, format: :js }
        not_best_answer.reload
        
        expect(not_best_answer.best).to eq false
      end
      
      it 'choose other best answer' do
        patch :best, params: { id: answer, format: :js }
        answer.reload
        not_best_answer.reload
        
        expect(answer.best).to eq true
        expect(not_best_answer.best).to eq false
      end
      
      it 'render best view' do
        expect(response).to render_template :best
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Own answers' do

      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
  
  it_behaves_like "voted", :answer
end
