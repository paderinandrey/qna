require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user

  let(:question) { create :question }
  let(:answer) { create(:answer, question: question, user: @user) }

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
      it 'edit answer'
      it 'render question show template'
    end

    context 'Other answer' do
      it 'edit answers'
      it 'render question show template'
    end
  end

  describe 'DELETE #destroy' do
    context 'Own answers' do

      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show view' do
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

      it 'redirect to show view' do
        delete :destroy, params: { id: alien_answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
