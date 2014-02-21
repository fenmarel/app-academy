NinetynineCats::Application.routes.draw do
  root to: 'cats#index'

  resources :cats, except: :index
  resources :cat_rental_requests, only: [:create, :new, :destroy] do
    member do
      patch :approve
      patch :deny
    end
  end

  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :multi_sessions, only: [:destroy]
end

