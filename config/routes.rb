Rails.application.routes.draw do
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/")
  get "signout", to: "sessions#destroy", as: "signout"

  root 'welcome#index'
end
