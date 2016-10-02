require 'rails_helper'

describe 'Profile API' do
  let(:options) { {} }
  
  describe 'GET /me' do
    
    let(:action) { :get }
    let(:path) { '/api/v1/profiles/me' }
   
    it_behaves_like "API Authenticable" 

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      
      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }
      
      it 'returns 200 status' do
        expect(response).to be_success
      end
      
      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end
      
      %w(password encrypted_password).each do |attr|      
        it "does not captain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end
  
  describe 'GET /index' do
    
    let(:action) { :get }
    let(:path) { '/api/v1/profiles' }
   
    it_behaves_like "API Authenticable" 
    
    context 'authorized' do
      let(:me) { create(:user) }
      let!(:aliens) { create_list(:user, 5) }
      let(:alien) { alien = aliens.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      
      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }
      
      it 'returns 200 status' do
        expect(response).to be_success
      end
      
      it 'does not contain me' do
        expect(response.body).to_not include_json(me.to_json)
      end
      
      it 'does contain other users' do
        expect(normalize_json(response.body)).to be_json_eql(normalize_json(aliens.to_json))
      end
      
      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
         expect(response.body).to have_json_path("0/#{ attr }")
        end
      end
      
      %w(password encrypted_password).each do |attr|      
        it "does not captain #{attr}" do
          expect(response.body).to_not have_json_path("0/#{ attr }")
        end
      end
    end
  end
end
