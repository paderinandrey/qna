Rails.application.routes.draw do
  devise_for :users
  
  concern :votable do
    member do
      post :like
      post :dislike
      patch :change_vote
      delete :cancel_vote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  
  root to: "questions#index"
end
