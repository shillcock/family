Rails.application.routes.draw do

  concern :lovable do
    resources :hearts, only: [:create, :destroy]
  end

  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/")
  get "sign_out", to: "sessions#destroy", as: "sign_out"

  resource :sign_in, only: [:show]

  resources :posts, concerns: :lovable, only: [:index, :create, :destroy] do
    resources :comments, only: [:create, :destroy]
  end

  resources :comments, concerns: :lovable, only: []

  resources :photos, only: [:index, :show] do
    member do
      get "download"
      get "view"
    end
  end

  root "posts#index"
end

