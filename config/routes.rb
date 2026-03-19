Rails.application.routes.draw do
  root "dashboard#index"
  get "camps", to: "camps#index"
  get "users", to: "users#index"
end