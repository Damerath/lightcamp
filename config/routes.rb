Rails.application.routes.draw do
  get 'admin_camp_applications/index'
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
  get "admin/camp_applications", to: "admin_camp_applications#index"
  patch "admin/camp_applications/:id/assignment", to: "admin_camp_applications#update_assignment", as: :admin_camp_application_assignment
  get "years", to: "years#index"
  post "years", to: "years#create"
  patch "years/:id", to: "years#update", as: :year
  patch "years/:id/toggle_registration", to: "years#toggle_registration", as: :toggle_year_registration
  get "profile", to: "profiles#edit"
  patch "profile", to: "profiles#update"
  get 'camp_applications/new'
  get "camp_application", to: "camp_applications#new"
  post "camp_application", to: "camp_applications#create"
end
