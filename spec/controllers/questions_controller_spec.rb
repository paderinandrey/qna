require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'create new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns anew Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'question belongs to user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user).to eq subject.current_user
      end

      it 'render to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'Edit own question' do

      before { question.update_attribute(:user, @user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 're-render new view' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: { body: nil } } }

        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq 'MyText'
        end

        it 're-render new view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'Edit other question' do
      let(:alien_user) { create(:user) }
      let!(:alien_question) { create(:question, user: alien_user) }

      before { patch :update, params: { id: alien_question, question: { title: 'new title', body: 'new body' } } }

      it 'Edit other question' do
        expect(alien_question.title).to eq alien_question.title
        expect(alien_question.body).to eq alien_question.body
      end

      it 'redirect to show view' do
        expect(response).to redirect_to alien_question
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'Own question' do

      before { question.update_attribute(:user, @user) }

      it 'delete own question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Other question' do
      let(:alien_user) { create(:user) }
      let!(:alien_question) { create(:question, user: alien_user) }

      it 'delete other question' do
        expect { delete :destroy, params: { id: alien_question } }.to_not change(Question, :count)
      end

      it 'redirect to show view' do
        delete :destroy, params: { id: alien_question }
        expect(response).to redirect_to alien_question
      end
    end
  end
end
