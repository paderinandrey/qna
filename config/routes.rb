require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  use_doorkeeper
  devise_for :users, skip: [:registrations], controllers: { omniauth_callbacks: 'omniauth_callbacks' } 
  
  devise_scope :user do
    post '/users/confirm_email', to: 'users#confirm_email', as: :confirm_email
    get '/users/signup', to: 'devise/registrations#new', as: :new_user_registration
    post '/users/signup', to: 'devise/registrations#create', as: :user_registration
  end
  
  concern :votable do
    member do
      post :like
      post :dislike
      patch :change_vote
      delete :cancel_vote
    end
  end

  # concern :commentable do
  #   resources :comments, shallow: true, only: [:update, :destroy] 
  #   post :add_comment, on: :member
  # end

  resources :questions, concerns: :votable do
    resources :comments, shallow: true, only: [:create, :update, :destroy], defaults: { commentable_type: 'question' }
    resources :answers, shallow: true, concerns: :votable do
      resources :comments, shallow: true, only: [:create, :update, :destroy], defaults: { commentable_type: 'answer' }
      patch :best, on: :member
    end
    
    member do
      post :subscribe
      delete :unsubscribe
    end  
  end

  resources :attachments, only: :destroy
  
  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end
  
  get 'search', to: 'search#index'
  
  root to: "questions#index"
end
