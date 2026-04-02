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
  get "camps/:camp_id/teams/:id", to: "camp_teams#show", as: :camp_team_page
  get "camps/:camp_id/teams/:id/shopping_print", to: "camp_teams#shopping_print", as: :camp_team_shopping_print
  get "camps/:camp_id/teams/:id/week_plan_print", to: "camp_teams#week_plan_print", as: :camp_team_week_plan_print
  get "camps/:camp_id/teams/:id/sport_tournament_print", to: "camp_teams#sport_tournament_print", as: :camp_team_sport_tournament_print
  get "camps/:camp_id/teams/:id/kitchen_plan_print", to: "camp_teams#kitchen_plan_print", as: :camp_team_kitchen_plan_print
  get "camps/:camp_id/teams/:id/diy_plan_print", to: "camp_teams#diy_plan_print", as: :camp_team_diy_plan_print
  get "camps/:camp_id/teams/:id/room_plan_print", to: "camp_teams#room_plan_print", as: :camp_team_room_plan_print
  get "camps/:camp_id/teams/:id/medical_supplies_print", to: "camp_teams#medical_supplies_print", as: :camp_team_medical_supplies_print
  patch "camps/:camp_id/teams/:id", to: "camp_teams#update"
  post "camps/:camp_id/teams/:team_id/sleeping_places", to: "camp_sleeping_places#create", as: :camp_sleeping_places
  patch "camps/:camp_id/teams/:team_id/sleeping_places/:id", to: "camp_sleeping_places#update", as: :camp_sleeping_place
  delete "camps/:camp_id/teams/:team_id/sleeping_places/:id", to: "camp_sleeping_places#destroy"
  patch "camps/:camp_id/teams/:team_id/sleeping_assignments/:id", to: "camp_sleeping_assignments#update", as: :camp_sleeping_assignment
  post "camps/:camp_id/teams/:team_id/room_people", to: "camp_room_people#create", as: :camp_room_people
  patch "camps/:camp_id/teams/:team_id/room_people/:id", to: "camp_room_people#update", as: :camp_room_person
  delete "camps/:camp_id/teams/:team_id/room_people/:id", to: "camp_room_people#destroy"
  post "camps/:camp_id/teams/:team_id/links", to: "camp_team_links#create", as: :camp_team_links
  patch "camps/:camp_id/teams/:team_id/links/:id", to: "camp_team_links#update", as: :camp_team_link
  delete "camps/:camp_id/teams/:team_id/links/:id", to: "camp_team_links#destroy"
  post "camps/:camp_id/teams/:team_id/download_items", to: "camp_team_download_items#create", as: :camp_team_download_items
  patch "camps/:camp_id/teams/:team_id/download_items/:id", to: "camp_team_download_items#update", as: :camp_team_download_item
  delete "camps/:camp_id/teams/:team_id/download_items/:id", to: "camp_team_download_items#destroy"
  post "camps/:camp_id/teams/:team_id/todos", to: "camp_team_todos#create", as: :camp_team_todos
  patch "camps/:camp_id/teams/:team_id/todos/:id", to: "camp_team_todos#update", as: :camp_team_todo
  delete "camps/:camp_id/teams/:team_id/todos/:id", to: "camp_team_todos#destroy"
  post "camps/:camp_id/teams/:team_id/shopping_items", to: "camp_team_shopping_items#create", as: :camp_team_shopping_items
  patch "camps/:camp_id/teams/:team_id/shopping_items/:id", to: "camp_team_shopping_items#update", as: :camp_team_shopping_item
  delete "camps/:camp_id/teams/:team_id/shopping_items/:id", to: "camp_team_shopping_items#destroy"
  patch "camps/:camp_id/teams/:team_id/sport_day_plans/:id", to: "camp_sport_day_plans#update", as: :camp_sport_day_plan
  post "camps/:camp_id/teams/:team_id/sport_material_items", to: "camp_sport_material_items#create", as: :camp_sport_material_items
  patch "camps/:camp_id/teams/:team_id/sport_material_items/:id", to: "camp_sport_material_items#update", as: :camp_sport_material_item
  delete "camps/:camp_id/teams/:team_id/sport_material_items/:id", to: "camp_sport_material_items#destroy"
  post "camps/:camp_id/teams/:team_id/medical_supplies", to: "medical_supply_items#create", as: :camp_medical_supply_items
  patch "camps/:camp_id/teams/:team_id/medical_supplies/:id", to: "medical_supply_items#update", as: :camp_medical_supply_item
  delete "camps/:camp_id/teams/:team_id/medical_supplies/:id", to: "medical_supply_items#destroy"
  patch "camps/:camp_id/teams/:team_id/kitchen_day_plans/:id", to: "camp_kitchen_day_plans#update", as: :camp_kitchen_day_plan
  patch "camps/:camp_id/teams/:team_id/diy_day_plans/:id", to: "camp_diy_day_plans#update", as: :camp_diy_day_plan
  post "camps/:camp_id/teams/:team_id/diy_day_plans/:id/apply_general_offer_to_all", to: "camp_diy_day_plans#apply_general_offer_to_all", as: :apply_general_offer_to_all_camp_diy_day_plan
  patch "camps/:camp_id/teams/:team_id/sport_tournament_plan", to: "camp_sport_tournament_plans#update", as: :camp_sport_tournament_plan
  post "camps/:camp_id/teams/:team_id/sport_tournament_plan/reset", to: "camp_sport_tournament_plans#reset", as: :reset_camp_sport_tournament_plan
  post "camps/:camp_id/teams/:team_id/program_blocks", to: "camp_program_blocks#create", as: :camp_program_blocks
  patch "camps/:camp_id/teams/:team_id/program_blocks/:id", to: "camp_program_blocks#update", as: :camp_program_block
  delete "camps/:camp_id/teams/:team_id/program_blocks/:id", to: "camp_program_blocks#destroy"
  post "camps/:camp_id/teams/:team_id/program_blocks/reset", to: "camp_program_blocks#reset", as: :reset_camp_program_blocks
  post "camps/:camp_id/teams/:team_id/week_days", to: "camp_program_week_days#create", as: :camp_program_week_days
  patch "camps/:camp_id/teams/:team_id/week_days/:id", to: "camp_program_week_days#update", as: :camp_program_week_day
  delete "camps/:camp_id/teams/:team_id/week_days/:id", to: "camp_program_week_days#destroy"
  post "camps/:camp_id/teams/:team_id/week_days/:week_day_id/week_blocks", to: "camp_program_week_blocks#create", as: :camp_program_week_blocks
  patch "camps/:camp_id/teams/:team_id/week_days/:week_day_id/week_blocks/:id", to: "camp_program_week_blocks#update", as: :camp_program_week_block
  delete "camps/:camp_id/teams/:team_id/week_days/:week_day_id/week_blocks/:id", to: "camp_program_week_blocks#destroy"
  get "users", to: "users#index"
  patch "users/:id", to: "users#update", as: :user
  delete "users/:id", to: "users#destroy"
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
  post "admin/camps/:camp_id/teams/:team_id/sleeping_places", to: "admin_camp_sleeping_places#create", as: :admin_camp_sleeping_places
  patch "admin/camps/:camp_id/teams/:team_id/sleeping_places/:id", to: "admin_camp_sleeping_places#update", as: :admin_camp_sleeping_place
  delete "admin/camps/:camp_id/teams/:team_id/sleeping_places/:id", to: "admin_camp_sleeping_places#destroy"
  patch "admin/camps/:camp_id/teams/:team_id/sleeping_assignments/:id", to: "admin_camp_sleeping_assignments#update", as: :admin_camp_sleeping_assignment
  post "admin/camps/:camp_id/teams/:team_id/room_people", to: "admin_camp_room_people#create", as: :admin_camp_room_people
  patch "admin/camps/:camp_id/teams/:team_id/room_people/:id", to: "admin_camp_room_people#update", as: :admin_camp_room_person
  delete "admin/camps/:camp_id/teams/:team_id/room_people/:id", to: "admin_camp_room_people#destroy"
  post "admin/camps/:camp_id/teams/:team_id/links", to: "admin_camp_team_links#create", as: :admin_camp_team_links
  patch "admin/camps/:camp_id/teams/:team_id/links/:id", to: "admin_camp_team_links#update", as: :admin_camp_team_link
  delete "admin/camps/:camp_id/teams/:team_id/links/:id", to: "admin_camp_team_links#destroy"
  post "admin/camps/:camp_id/teams/:team_id/download_items", to: "admin_camp_team_download_items#create", as: :admin_camp_team_download_items
  patch "admin/camps/:camp_id/teams/:team_id/download_items/:id", to: "admin_camp_team_download_items#update", as: :admin_camp_team_download_item
  delete "admin/camps/:camp_id/teams/:team_id/download_items/:id", to: "admin_camp_team_download_items#destroy"
  post "admin/camps/:camp_id/teams/:team_id/todos", to: "admin_camp_team_todos#create", as: :admin_camp_team_todos
  patch "admin/camps/:camp_id/teams/:team_id/todos/:id", to: "admin_camp_team_todos#update", as: :admin_camp_team_todo
  delete "admin/camps/:camp_id/teams/:team_id/todos/:id", to: "admin_camp_team_todos#destroy"
  post "admin/camps/:camp_id/teams/:team_id/shopping_items", to: "admin_camp_team_shopping_items#create", as: :admin_camp_team_shopping_items
  patch "admin/camps/:camp_id/teams/:team_id/shopping_items/:id", to: "admin_camp_team_shopping_items#update", as: :admin_camp_team_shopping_item
  delete "admin/camps/:camp_id/teams/:team_id/shopping_items/:id", to: "admin_camp_team_shopping_items#destroy"
  patch "admin/camps/:camp_id/teams/:team_id/sport_day_plans/:id", to: "admin_camp_sport_day_plans#update", as: :admin_camp_sport_day_plan
  post "admin/camps/:camp_id/teams/:team_id/sport_material_items", to: "admin_camp_sport_material_items#create", as: :admin_camp_sport_material_items
  patch "admin/camps/:camp_id/teams/:team_id/sport_material_items/:id", to: "admin_camp_sport_material_items#update", as: :admin_camp_sport_material_item
  delete "admin/camps/:camp_id/teams/:team_id/sport_material_items/:id", to: "admin_camp_sport_material_items#destroy"
  post "admin/camps/:camp_id/teams/:team_id/medical_supplies", to: "admin_medical_supply_items#create", as: :admin_camp_medical_supply_items
  patch "admin/camps/:camp_id/teams/:team_id/medical_supplies/:id", to: "admin_medical_supply_items#update", as: :admin_camp_medical_supply_item
  delete "admin/camps/:camp_id/teams/:team_id/medical_supplies/:id", to: "admin_medical_supply_items#destroy"
  patch "admin/camps/:camp_id/teams/:team_id/kitchen_day_plans/:id", to: "admin_camp_kitchen_day_plans#update", as: :admin_camp_kitchen_day_plan
  patch "admin/camps/:camp_id/teams/:team_id/diy_day_plans/:id", to: "admin_camp_diy_day_plans#update", as: :admin_camp_diy_day_plan
  post "admin/camps/:camp_id/teams/:team_id/diy_day_plans/:id/apply_general_offer_to_all", to: "admin_camp_diy_day_plans#apply_general_offer_to_all", as: :apply_general_offer_to_all_admin_camp_diy_day_plan
  patch "admin/camps/:camp_id/teams/:team_id/sport_tournament_plan", to: "admin_camp_sport_tournament_plans#update", as: :admin_camp_sport_tournament_plan
  post "admin/camps/:camp_id/teams/:team_id/sport_tournament_plan/reset", to: "admin_camp_sport_tournament_plans#reset", as: :reset_admin_camp_sport_tournament_plan
  post "admin/camps/:camp_id/teams/:team_id/program_blocks", to: "admin_camp_program_blocks#create", as: :admin_camp_program_blocks
  patch "admin/camps/:camp_id/teams/:team_id/program_blocks/:id", to: "admin_camp_program_blocks#update", as: :admin_camp_program_block
  delete "admin/camps/:camp_id/teams/:team_id/program_blocks/:id", to: "admin_camp_program_blocks#destroy"
  post "admin/camps/:camp_id/teams/:team_id/program_blocks/reset", to: "admin_camp_program_blocks#reset", as: :reset_admin_camp_program_blocks
  post "admin/camps/:camp_id/teams/:team_id/week_days", to: "admin_camp_program_week_days#create", as: :admin_camp_program_week_days
  patch "admin/camps/:camp_id/teams/:team_id/week_days/:id", to: "admin_camp_program_week_days#update", as: :admin_camp_program_week_day
  delete "admin/camps/:camp_id/teams/:team_id/week_days/:id", to: "admin_camp_program_week_days#destroy"
  post "admin/camps/:camp_id/teams/:team_id/week_days/:week_day_id/week_blocks", to: "admin_camp_program_week_blocks#create", as: :admin_camp_program_week_blocks
  patch "admin/camps/:camp_id/teams/:team_id/week_days/:week_day_id/week_blocks/:id", to: "admin_camp_program_week_blocks#update", as: :admin_camp_program_week_block
  delete "admin/camps/:camp_id/teams/:team_id/week_days/:week_day_id/week_blocks/:id", to: "admin_camp_program_week_blocks#destroy"
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
  get 'camp_applications/new'
  get "camp_application", to: "camp_applications#new"
  post "camp_application", to: "camp_applications#create"
end
