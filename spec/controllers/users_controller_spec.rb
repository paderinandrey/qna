require 'rails_helper'
require 'capybara/email'

RSpec.describe UsersController, type: :controller do
  describe 'POST #confirm_email' do
    context 'with valid attributes' do
      before { session["devise.omniauth_data"] = { provider: 'facebook', uid: '123456789' } }
      it 'saves the new user in the database' do
        expect { post :confirm_email, params: { user: attributes_for(:user), email: 'test@test.com' } }.to change(User, :count).by(1)
      end

      it 'redirect to root url' do
        post :confirm_email, params: { user: attributes_for(:user), email: 'test@test.com' }
        expect(response).to redirect_to root_url
      end
    end
  end
end
