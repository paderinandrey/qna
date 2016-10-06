require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }
  
  describe 'GET #index' do
    let!(:questions) { create_list(:question, 2) }

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
    let(:question) { create(:question, user: @user) }
    
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

  describe 'DELETE #destroy' do
    sign_in_user

    before { question.update_attribute(:user, @user) }

    it 'delete question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

  describe 'POST #subscribe' do
    sign_in_user
    
    it 'saves the new subscribe in the database' do
      expect { post :subscribe, params: { id: attributes_for(:question) } }.to change(Question, :count).by(1)
    end
    
    it 'subscribe belongs to user' do
      post :subscribe, params: { question: attributes_for(:question) }
      
      expect(assigns(:question).user).to eq subject.current_user
    end
    
    it 'render to show view' do
      post :subscribe, params: { question: attributes_for(:question) }
      
      expect(response).to redirect_to question_path(assigns(:question))
    end
  end
  
  describe 'DELETE #unsubscribe' do
    sign_in_user
  end

  it_behaves_like "voted", :question
end
