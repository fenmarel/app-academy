MusicInventory::Application.routes.draw do
  root to: "users#index"

  resources :users
  resource :session, only: [:new, :create, :destroy]

  resources :bands do
    resources :albums, :only => [:new, :create] do
      resources :tracks, :only => [:new, :create]
    end
  end

  resources :albums, :except => [:index, :new, :create]
  resources :tracks, :except => [:index, :new, :create]
end
