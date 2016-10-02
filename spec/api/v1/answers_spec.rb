require 'rails_helper'

describe 'Answers API' do
  let(:options) { {} }
  
  describe 'GET /index' do
    let(:question) { create(:question) }
    
    let(:action) { :get }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }
   
    it_behaves_like "API Authenticable" 
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } } 
      
      it 'returns 200 status code' do
        expect(response).to be_success
      end
    
      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end
      
      %w(id body created_at updated_at).each do |attr|
        it "Answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end
  
  describe 'GET /show' do
    let(:answer) { create(:answer) }
    
    let(:action) { :get }
    let(:path) { "/api/v1/answers/#{answer.id}" }
   
    it_behaves_like "API Authenticable" 
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
      
      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } } 
      
      it 'returns 200 status code' do
        expect(response).to be_success
      end
    
      %w(id body created_at updated_at).each do |attr|
        it "Answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
      
      it_behaves_like "API Commentable", :answer

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(2).at_path("answer/attachments")
        end
        
        it "Attachments object contains url" do
          expect(response.body).to be_json_eql(attachments.last.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end  
    end
  end
  
  describe 'POST /create' do
    let(:question) { create(:question) }
    
    let(:action) { :post }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }
    let(:options) { { answer: attributes_for(:answer) } }
   
    it_behaves_like "API Authenticable" 
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      
      context 'with valid attributes' do
        it 'saves the new answer in the database' do
         expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }.to change(Answer, :count).by(1)
        end 
        
        it 'answer belongs to user' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          expect(assigns(:answer).user).to eq User.find(access_token.resource_owner_id)
        end
        
        it "returns answer" do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          %w(id body created_at updated_at).each do |attr|
            expect(response.body).to be_json_eql(Answer.first.send(attr.to_sym).to_json).at_path("answer/#{attr}")
          end
        end
      end
      
      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token } }.to_not change(Answer, :count)
        end
        
        it 'returns error' do
          post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token }
          expect(response.body).to have_json_path("errors")
        end
      end  
    end
  end
end
