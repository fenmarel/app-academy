MusicInventory::Application.routes.draw do
  root to: "bands#index"

  resources :users do
    collection do
      get "activate"
    end
  end

  resource :session, only: [:new, :create, :destroy]

  resources :bands do
    resources :albums, :only => [:index, :new, :create] do
      resources :tracks, :only => [:new, :create]
      resources :owns, :only => [:create]
    end
  end

  resources :albums, :except => [:index, :new, :create]
  resources :tracks, :except => [:index, :new, :create]
  resources :owns, :only => [:destroy]
end
