Rails.application.routes.draw do
  # Diese Schreibaktionen sind für Teammitglieder und Leitung gleich. Das Concern
  # wird unten in beide URL-Bereiche eingebunden, damit Pfade und Helper stabil bleiben.
  concern :team_workspace_actions do
    resources :sleeping_places, controller: "camp_sleeping_places", only: %i[create update destroy]
    resources :sleeping_assignments, controller: "camp_sleeping_assignments", only: :update
    resources :room_people, controller: "camp_room_people", only: %i[create update destroy]
    resources :team_links, path: "links", controller: "camp_team_links", only: %i[create update destroy]
    resources :team_download_items, path: "download_items", controller: "camp_team_download_items", only: %i[create update destroy]
    resources :team_todos, path: "todos", controller: "camp_team_todos", only: %i[create update destroy]
    resources :team_shopping_items, path: "shopping_items", controller: "camp_team_shopping_items", only: %i[create update destroy]
    resources :sport_day_plans, controller: "camp_sport_day_plans", only: :update
    resources :sport_material_items, controller: "camp_sport_material_items", only: %i[create update destroy]
    resources :kitchen_day_plans, controller: "camp_kitchen_day_plans", only: :update
    resources :diy_day_plans, controller: "camp_diy_day_plans", only: :update do
      post :apply_general_offer_to_all, on: :member
    end
    resource :sport_tournament_plan, controller: "camp_sport_tournament_plans", only: :update do
      post :reset
    end
    resources :program_blocks, controller: "camp_program_blocks", only: %i[create update destroy] do
      post :reset, on: :collection
    end
    resources :program_week_days, path: "week_days", controller: "camp_program_week_days", only: %i[create update destroy]
    scope "week_days/:week_day_id", as: :program_week do
      resources :blocks, path: "week_blocks", controller: "camp_program_week_blocks", only: %i[create update destroy]
    end
  end

  get 'admin_camp_applications/index'
  get 'profiles/edit'
  get 'years/index'
  devise_for :users, controllers: { registrations: "users/registrations" }
  root "dashboard#index"
  get "impressum", to: "legal_pages#imprint"
  get "datenschutz", to: "legal_pages#privacy"
  get "nutzungsbedingungen", to: "legal_pages#terms"
  resources :camps, only: %i[index create update destroy]

  get "camps/:camp_id/teams/:id", to: "camp_teams#show", as: :camp_team_page
  patch "camps/:camp_id/teams/:id", to: "camp_teams#update"
  get "camps/:camp_id/teams/:id/shopping_print", to: "camp_teams#shopping_print", as: :camp_team_shopping_print
  get "camps/:camp_id/teams/:id/week_plan_print", to: "camp_teams#week_plan_print", as: :camp_team_week_plan_print
  get "camps/:camp_id/teams/:id/sport_tournament_print", to: "camp_teams#sport_tournament_print", as: :camp_team_sport_tournament_print
  get "camps/:camp_id/teams/:id/kitchen_plan_print", to: "camp_teams#kitchen_plan_print", as: :camp_team_kitchen_plan_print
  get "camps/:camp_id/teams/:id/diy_plan_print", to: "camp_teams#diy_plan_print", as: :camp_team_diy_plan_print
  get "camps/:camp_id/teams/:id/room_plan_print", to: "camp_teams#room_plan_print", as: :camp_team_room_plan_print
  get "camps/:camp_id/teams/:id/medical_supplies_print", to: "camp_teams#medical_supplies_print", as: :camp_team_medical_supplies_print

  # Teammitglieder verwenden diese Routen nach Prüfung ihrer Teamzuordnung.
  scope "camps/:camp_id/teams/:team_id", as: :camp do
    concerns :team_workspace_actions
    resources :medical_supply_items, path: "medical_supplies", controller: "medical_supply_items", only: %i[create update destroy]
  end
  get "users", to: "users#index"
  patch "users/:id", to: "users#update", as: :user
  delete "users/:id", to: "users#destroy"
  get "leitung", to: "leadership#index", as: :leadership
  get "admin", to: "admin#index"
  get "admin/downloads", to: "admin_download_items#index", as: :admin_download_items
  post "admin/downloads/items", to: "admin_download_items#create", as: :admin_download_items_create
  patch "admin/downloads/items/:id", to: "admin_download_items#update", as: :admin_download_item
  delete "admin/downloads/items/:id", to: "admin_download_items#destroy"
  get "admin/lists/sport_materials", to: "admin_sport_material_lists#show", as: :admin_sport_material_list
  post "admin/lists/sport_materials/items", to: "admin_sport_material_lists#create", as: :admin_sport_material_items
  patch "admin/lists/sport_materials/items/:id", to: "admin_sport_material_lists#update", as: :admin_sport_material_item
  delete "admin/lists/sport_materials/items/:id", to: "admin_sport_material_lists#destroy"
  get "admin/lists/medical_supplies", to: "admin_medical_supply_lists#show", as: :admin_medical_supply_list
  post "admin/lists/medical_supplies/items", to: "admin_medical_supply_lists#create", as: :admin_medical_supply_items
  patch "admin/lists/medical_supplies/items/:id", to: "admin_medical_supply_lists#update", as: :admin_medical_supply_item
  delete "admin/lists/medical_supplies/items/:id", to: "admin_medical_supply_lists#destroy"
  get "admin/camps", to: "admin_camps#index"
  get "admin/camps/:camp_id/teams", to: "admin_camp_teams#index", as: :admin_camp_teams
  get "admin/camps/:camp_id/teams/:id", to: "admin_camp_teams#show", as: :admin_camp_team_page
  get "admin/camps/:camp_id/teams/:id/shopping_print", to: "admin_camp_teams#shopping_print", as: :admin_camp_team_shopping_print
  get "admin/camps/:camp_id/teams/:id/week_plan_print", to: "admin_camp_teams#week_plan_print", as: :admin_camp_team_week_plan_print
  get "admin/camps/:camp_id/teams/:id/sport_tournament_print", to: "admin_camp_teams#sport_tournament_print", as: :admin_camp_team_sport_tournament_print
  get "admin/camps/:camp_id/teams/:id/kitchen_plan_print", to: "admin_camp_teams#kitchen_plan_print", as: :admin_camp_team_kitchen_plan_print
  get "admin/camps/:camp_id/teams/:id/diy_plan_print", to: "admin_camp_teams#diy_plan_print", as: :admin_camp_team_diy_plan_print
  get "admin/camps/:camp_id/teams/:id/room_plan_print", to: "admin_camp_teams#room_plan_print", as: :admin_camp_team_room_plan_print
  get "admin/camps/:camp_id/teams/:id/medical_supplies_print", to: "admin_camp_teams#medical_supplies_print", as: :admin_camp_team_medical_supplies_print
  patch "admin/camps/:camp_id/teams/:id", to: "admin_camp_teams#update", as: :admin_camp_team
  # Leitung verwendet dieselben Schreibcontroller, behält aber eigene URLs und Helper.
  scope "admin/camps/:camp_id/teams/:team_id", as: :admin_camp do
    concerns :team_workspace_actions
    resources :medical_supply_items, path: "medical_supplies", controller: "admin_medical_supply_items", only: %i[create update destroy]
  end
  get "admin/team_templates", to: "admin_team_templates#index", as: :admin_team_templates
  get "admin/team_templates/:id", to: "admin_team_templates#show", as: :admin_team_template
  patch "admin/team_templates/:id", to: "admin_team_templates#update"
  post "admin/team_templates/:team_template_id/links", to: "admin_team_template_links#create", as: :admin_team_template_links
  patch "admin/team_templates/:team_template_id/links/:id", to: "admin_team_template_links#update", as: :admin_team_template_link
  delete "admin/team_templates/:team_template_id/links/:id", to: "admin_team_template_links#destroy"
  post "admin/team_templates/:team_template_id/download_items", to: "admin_team_template_download_items#create", as: :admin_team_template_download_items
  patch "admin/team_templates/:team_template_id/download_items/:id", to: "admin_team_template_download_items#update", as: :admin_team_template_download_item
  delete "admin/team_templates/:team_template_id/download_items/:id", to: "admin_team_template_download_items#destroy"
  get "admin/camp_applications", to: "admin_camp_applications#index"
  patch "admin/camp_applications/:id/assignment", to: "admin_camp_applications#update_assignment", as: :admin_camp_application_assignment
  get "years", to: "years#index"
  post "years", to: "years#create"
  patch "years/:id", to: "years#update", as: :year
  patch "years/:id/toggle_registration", to: "years#toggle_registration", as: :toggle_year_registration
  get "profile", to: "profiles#edit"
  patch "profile", to: "profiles#update"
  get "notifications/:id/visit", to: "notification_deliveries#visit", as: :notification_delivery_visit
  patch "notifications/:id/dismiss", to: "notification_deliveries#dismiss", as: :notification_delivery_dismiss
  get 'camp_applications/new'
  get "camp_application", to: "camp_applications#new"
  post "camp_application", to: "camp_applications#create"
end
