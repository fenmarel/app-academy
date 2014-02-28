RedditClone::Application.routes.draw do
  root to: "subs#index"

  resources :users
  resource :session
  resources :subs

  resources :links do
    member do
      post "upvote"
      post "downvote"
    end

    resources :comments
  end


end
