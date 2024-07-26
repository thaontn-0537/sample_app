Rails.application.routes.draw do
  get "static_pages/home"
  get "static_pages/help"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: :show

  # Defines the root path route ("/")
  root "static_pages#home"
end
