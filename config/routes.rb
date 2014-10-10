Rails.application.routes.draw do
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/")
  get "sign_out", to: "sessions#destroy", as: "sign_out"

  resource :sign_in, only: [:show]

  resources :posts, only: [:index, :create, :destroy] do
    resources :comments, only: [:create, :destroy]
    resources :hearts, only: [:create, :destroy]
  end

  resources :comments, only: [] do
    resources :hearts, only: [:create, :destroy]
  end

  root "posts#index"
end

