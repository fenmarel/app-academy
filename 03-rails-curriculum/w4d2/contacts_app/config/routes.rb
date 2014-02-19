ContactsApp::Application.routes.draw do
  resources :users, :except => [:new, :edit] do
    resources :contacts, :only => [:index]
    get 'contacts/favorites' => 'contacts#favorites'
    resources :groups, :except => [:new, :edit]
  end
  resources :contacts, :except => [:new, :edit, :index] do
    put 'toggle_fav' => 'contacts#toggle_fav'
  end

  resources :contact_shares, :only => [:create, :destroy]
  resources :group_joins, :only => [:create, :destroy]
end
