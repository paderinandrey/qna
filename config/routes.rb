Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true do
      patch :best, on: :member
      #post :create, to: 'answers#create', :defaults => { :format => 'js' }
    end
  end

  root to: "questions#index"
end
