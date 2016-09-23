Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' } 
  
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
  end

  resources :attachments, only: :destroy
  
  #match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
 # match '/users/:id/confirm_email' => 'users#confirm_email', via: [:get, :patch], :as => :confirm_email
  match '/users/confirm_email' => 'users#confirm_email', via: :post, as: :confirm_email
  
  root to: "questions#index"
end
