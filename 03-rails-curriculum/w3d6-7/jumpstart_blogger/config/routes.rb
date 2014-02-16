JumpstartBlogger::Application.routes.draw do
  root to: 'articles#index'

  resources :articles, except: :index do
    resources :comments, only: :create
  end

  resources :tags

end
