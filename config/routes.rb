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
  resources :posts, concerns: :lovable, only: [:index, :create, :show, :destroy] do
    #comments
    resources :comments, only: [:create]
  end

  # comments
  resources :comments, concerns: :lovable, only: [:show, :destroy]

  # photos
  resources :photos, only: [:index, :show] do
    member do
      get "view"
    end
  end

  # resources :users, only: [:show]

  # twilio webhooks
  post "/voice", to: "comms#voice"
  post "/sms", to: "comms#sms"

  # users
  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get "posts"
      get "comments"
      get "hearts"
      get "photos"
    end
  end
#  get "/:id", to: "users#show", as: :user

  # default to posts index
  root "posts#index"
end

