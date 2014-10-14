Rails.application.routes.draw do
  concern :lovable do
    resources :hearts, only: [:create, :destroy]
  end

  # sessions
  get "sign_out", to: "sessions#destroy", as: "sign_out"
  resources :sessions, only: [:new, :create] do
    collection do
      get "status"
    end
  end

  # posts
  resources :posts, concerns: :lovable, only: [:index, :create, :destroy] do
    #comments
    resources :comments, only: [:create, :destroy]
  end

  # comments
  resources :comments, concerns: :lovable, only: []

  # photos
  resources :photos, only: [:index, :show] do
    member do
      get "download"
      get "view"
    end
  end

  # twilio webhooks
  post "/voice", to: "comms#voice"
  post "/sms", to: "comms#sms"

  # default to posts index
  root "posts#index"
end

