Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "static_pages/home"
  get "static_pages/help"
  get "/signup", to: "users#new"
  resources :users, only: %i(show create edit update index destroy)
  resources :password_resets, only: %i(new edit create update)
  resources :account_activations, only: :edit

  # Defines the root path route ("/")
  root "static_pages#home"
end
