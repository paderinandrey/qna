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
    
    context 'Own answers' do
      before { answer.update_attribute(:user, @user) }
      
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

    context 'Other answer' do
      let(:alien_user) { create(:user) }
      let!(:alien_answer) { create(:answer, question: question, user: alien_user) }
      
      before do
        patch :update, params: { id: alien_answer, answer: { body: 'new body' }, format: :js } 
        alien_answer.reload
      end
      
      it 'edit answers' do
        expect(alien_answer.body).to_not eq 'new body'
      end
      
      it 'render update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'GET #best' do
    let(:alien_user) { create(:user) }
    let!(:best_answer) { create(:answer, question: question, user: alien_user, best: false) }
    
    context 'Author of question' do
      before do
        question.update_attribute(:user, @user)
        get :best, xhr: true, params: { answer_id: best_answer, format: :js }
        best_answer.reload
      end  

      it 'assigns the requested answer_id to @answer' do
        expect(assigns(:answer)).to eq best_answer
      end
      
      it 'set the best answer' do
        expect(best_answer.best).to eq true
      end
      
      it 'cancel best answer' do
        get :best, xhr: true, params: { answer_id: best_answer, format: :js }
        best_answer.reload
        
        expect(best_answer.best).to eq false
      end
      
      it 'choose other best answer' do
        get :best, xhr: true, params: { answer_id: answer, format: :js }
        answer.reload
        best_answer.reload
        
        expect(answer.best).to eq true
        expect(best_answer.best).to eq false
      end
      
      it 'render best view' do
        expect(response).to render_template :best
      end
    end
    
    context 'Alien user' do
      it 'try set best answer' do
        get :best, xhr: true, params: { answer_id: answer, format: :js }
        answer.reload
        
        expect(answer.best).to eq false
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

    context 'Other answers' do
      let(:alien_user) { create(:user) }
      let!(:alien_answer) { create(:answer, question: question, user: alien_user) }

      it 'delete other answer' do
        expect { delete :destroy, params: { id: alien_answer, format: :js } }.to_not change(Answer, :count)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: alien_answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
