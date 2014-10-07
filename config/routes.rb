Rails.application.routes.draw do
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/")
  get "sign_out", to: "sessions#destroy", as: "sign_out"

  resource :sign_in, only: [:show]

  resources :posts do
    resources :comments do
      resources :hearts, only: [:create]
    end
    resources :hearts, only: [:create]
  end

  root "posts#index"
end

