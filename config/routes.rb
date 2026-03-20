Rails.application.routes.draw do
  devise_for :users
  root "dashboard#index"
  get "camps", to: "camps#index"
  get "users", to: "users#index"
  get "admin", to: "admin#index"

end