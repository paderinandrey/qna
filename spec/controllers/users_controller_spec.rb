require 'rails_helper'
require 'capybara/email'

RSpec.describe UsersController, type: :controller do
  describe 'POST #confirm_email' do
    context 'with valid attributes' do
      before do 
        mock_auth_hash[:twitter]
        session['devise.omniauth_data'] = OmniAuth.config.mock_auth[:twitter]
      end
      it 'saves the new user in the database' do
        expect { post :confirm_email, params: { user: attributes_for(:user), email: 'test@test.com' } }.to change(User, :count).by(1)
      end

      it 'redirect to root url' do
        post :confirm_email, params: { user: attributes_for(:user), email: 'test@test.com' }
        expect(response).to redirect_to root_url
      end
    end
    
    context 'with invalid session params' do
      it 'saves the new user in the database' do
        expect { post :confirm_email, params: { user: attributes_for(:user), email: 'test@test.com' } }.to_not change(User, :count)
      end

      it 'redirect to root url' do
        post :confirm_email, params: { user: attributes_for(:user), email: 'test@test.com' }
        expect(response).to redirect_to new_user_registration_url
      end
    end
    
    # context 'with invalid user params' do
    #   before do 
    #     mock_auth_hash[:twitter]
    #     session['devise.omniauth_data'] = OmniAuth.config.mock_auth[:twitter]
    #   end
    #   it 'saves the new user in the database' do
    #     #expect { 
    #     post :confirm_email, params: { user: attributes_for(:invalid_user) } #}.to_not change(User, :count)
    #     expect(response).to be_error
    #   end

    #   it 'redirect to root url' do
    #     post :confirm_email, params: { user: attributes_for(:invalid_user) }
    #     expect(response).to redirect_to root_url
    #   end
    # end
  end
end
