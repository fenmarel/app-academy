GoalApp::Application.routes.draw do

  root :to => 'users#new'

  resources :users, :only => [:new, :create, :show] do
    resources :comments, shallow: true, :only => [:create, :destroy]
    resources :goals, shallow: true, :except => [:index] do
      post :complete, on: :member
      resources :comments, shallow: true, :only => [:create, :destroy]
    end
  end
  resource :session, :only => [:new, :create, :destroy]
end
