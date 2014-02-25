SocialThing::Application.routes.draw do

  resources :users, :only => [:create, :new, :show] do
    resources :friend_circles, :only => [:new, :create, :edit, :update]
    resources :posts do
      resources :links, :only => [:create, :destroy]
    end

    member do
      get 'forgot_password'
      get 'feed'
    end
  end

  resource :session, :only => [:create, :new, :destroy] do
    collection do
      get "new_password_reset"
      post "send_password_reset"
    end
  end
end
