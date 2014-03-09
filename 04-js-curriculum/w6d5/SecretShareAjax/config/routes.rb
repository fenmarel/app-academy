SecretShareAjax::Application.routes.draw do
  resources :users, :only => [:create, :new, :show] do
    resources :secrets, :only => :new
  end

  resources :secrets, :only => :create

  resource :session, :only => [:create, :destroy, :new]

  root :to => "users#show"
end
