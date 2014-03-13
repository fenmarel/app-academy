NewReader::Application.routes.draw do
  resources :feeds, only: [:index, :show, :create] do
    resources :entries, only: [:index]
  end

  root to: "feeds#index"
end
