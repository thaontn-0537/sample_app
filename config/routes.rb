Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "static_pages/home"
  get "static_pages/help"
  get "/signup", to: "users#new"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :password_resets, only: %i(new edit create update)
  resources :account_activations, only: :edit
  resources :microposts, only: %i(create destroy)
  resources :relationships, only: %i(create destroy)
  
  # Defines the root path route ("/")
  root "static_pages#home"
end
