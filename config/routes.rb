Rails.application.routes.draw do
  get 'profiles/edit'
  get 'years/index'
  devise_for :users
  root "dashboard#index"
  get "camps", to: "camps#index"
  post "camps", to: "camps#create"
  patch "camps/:id", to: "camps#update", as: :camp
  delete "camps/:id", to: "camps#destroy"
  get "users", to: "users#index"
  get "admin", to: "admin#index"
  get "admin/camps", to: "admin_camps#index"
  get "years", to: "years#index"
  post "years", to: "years#create"
  patch "years/:id", to: "years#update", as: :year
  get "profile", to: "profiles#edit"
  patch "profile", to: "profiles#update"
end