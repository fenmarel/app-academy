NewAuthDemo::Application.routes.draw do
  get "/home", to: "static_pages#home"
  get "/contact", to: "static_pages#contact"
  get "/about", to: "static_pages#about"

  resources :users, :only => [:create, :new, :show]
  resource :session, :only => [:create, :destroy, :new]

  root :to => "users#show"
end
