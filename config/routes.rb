Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'welcome#index'
  resources :merchants

  resources :items, only: [:index, :show, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end

  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"

  resources :reviews, only: [:destroy, :edit, :update]

  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#destroy"
  patch "/cart/:item_id/:quantity", to: "cart_items#update"
  post "/cart/:item_id", to: "cart_items#create"
  delete "/cart/:item_id", to: "cart_items#destroy"

  get "/profile/orders/new", to: "user_orders#new"
  post "/profile/orders", to: "user_orders#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#show"

  get "/register", to: "register#new"
  post "/register", to: "register#create"

  get "/profile", to: "profiles#show"
  get "/profile/orders", to: 'user_orders#index'

  get "/profile/orders/:id", to: 'user_orders#show'

  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/edit_password", to: "users_password#edit"
  patch '/profile/edit_password', to: "users_password#update"

  patch "/profile/orders/:order_id/cancel", to: "user_orders#destroy"

  namespace :merchant do
    put "items/:id", to: "items_active#update"
    patch "items/:id", to: "items#update"
    resources :items, only: [:index, :edit, :new, :create, :destroy]
    resources :discounts, only: [:index, :edit, :update, :new, :create, :destroy]
    get '/', to: "dashboard#show"
    patch '/:order_id/:item_id', to: "orders#update"
    get "/orders/:id", to: "orders#show"
  end

  namespace :admin do
    get '/', to: "dashboard#show"
    resources :users, only: [:index, :show]
    patch '/:id', to: 'merchants#update'
    patch '/merchants/:id', to: 'merchants_active#update'
    get '/merchants/:id/items', to: 'merchant_items#index'
    put '/merchants/:id/', to: 'merchants_individual#update'
    get '/merchants/:id/merchant_items/add-item', to: 'merchant_items#new'
    put '/merchants/:merchant_id/merchant_items/:id', to: 'merchant_items#update'
    patch '/merchants/:merchant_id/merchant_items/:id', to: 'merchant_items_active#update'
    patch '/merchants/:merchant_id/merchant_orders/:order_id/:item_id', to: 'merchant_orders#update'
    resources :merchants, only: [:index, :new, :create, :destroy, :show, :edit] do
      resources :merchant_orders, only: [:show]
      resources :merchant_items, except: [:show, :update]
    end
  end

end
