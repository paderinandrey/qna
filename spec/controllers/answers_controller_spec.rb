require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user

  let(:question) { create :question }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saves new answer in the db' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'answer belongs to user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).user).to eq subject.current_user
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
    context 'Own answer' do
      it 'edit answer' do
      end

      it 'render question show template' do
      end
    end

    context 'Other answer' do
      it 'edit answer' do
      end

      it 'render question show template' do
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Own answer' do
      before { answer.update_attribute(:user, @user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(question.answers, :count).by(-1)
      end

      it 'render question show template' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'Other answer' do
      let(:alien_user) { create(:user) }
      let!(:alien_answer) { create(:answer, question: question, user: alien_user) }

      it 'delete other answer' do
        expect { delete :destroy, params: { id: alien_answer, question_id: question } }.to_not change(question.answers, :count)
      end

      it 'redirect to show view' do
        delete :destroy, params: { id: alien_answer, question_id: question }
        expect(response).to redirect_to question
      end
    end
  end
end
