Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' } 
  match '/users/confirm_email' => 'users#confirm_email', via: :post, as: :confirm_email
  
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
  
  root to: "questions#index"
end
