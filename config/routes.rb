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
  
  #concern :commentable do
    #member do
     # post :create_comment
      #patch :update_comment
      #delete :destroy_comment  
   # end
   # resources :comments, shallow: true, only: [:create, :update, :destroy]
 # end
  concern :commentable do
    #member do
    
    resources :comments, shallow: true, only: [:update, :destroy] 
  #end
    post :add_comment, on: :member
      #post :create_comment, on: :member
    #  patch :change_comment
     # delete :delete_comment
    #end
    #end
  end

#collection do
  resources :questions, concerns: [:votable, :commentable] do
    #resources :comments, shallow: true, only: [:create, :update, :destroy], defaults: { commentable: 'question' }
    resources :answers, shallow: true, concerns: [:votable, :commentable] do
      #resources :comments, shallow: true, only: [:create, :update, :destroy], defaults: { commentable: 'answer' }
      patch :best, on: :member
    end
  end
#end
  resources :attachments, only: :destroy
  
  root to: "questions#index"
end
