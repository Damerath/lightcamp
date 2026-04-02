# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_04_02_103100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "camp_application_choices", force: :cascade do |t|
    t.bigint "camp_application_id", null: false
    t.bigint "camp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_application_id"], name: "index_camp_application_choices_on_camp_application_id"
    t.index ["camp_id"], name: "index_camp_application_choices_on_camp_id"
  end

  create_table "camp_applications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "year_id", null: false
    t.text "motivation"
    t.string "commitment"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "uncertain_until"
    t.string "team_preference"
    t.boolean "responsible", default: false
    t.boolean "health_restrictions", default: false
    t.text "health_restrictions_details"
    t.bigint "assigned_camp_id"
    t.string "assigned_team"
    t.bigint "assigned_camp_team_id"
    t.boolean "assigned_as_responsible", default: false, null: false
    t.bigint "camp_sleeping_place_id"
    t.index ["assigned_camp_id"], name: "index_camp_applications_on_assigned_camp_id"
    t.index ["assigned_camp_team_id"], name: "index_camp_applications_on_assigned_camp_team_id"
    t.index ["camp_sleeping_place_id"], name: "index_camp_applications_on_camp_sleeping_place_id"
    t.index ["user_id"], name: "index_camp_applications_on_user_id"
    t.index ["year_id"], name: "index_camp_applications_on_year_id"
  end

  create_table "camp_diy_day_plans", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.date "planned_on", null: false
    t.integer "position", default: 0, null: false
    t.text "general_offer"
    t.text "daily_special"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id", "planned_on"], name: "index_camp_diy_day_plans_on_camp_team_id_and_planned_on", unique: true
    t.index ["camp_team_id"], name: "index_camp_diy_day_plans_on_camp_team_id"
  end

  create_table "camp_kitchen_day_plans", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.date "planned_on", null: false
    t.integer "position", default: 0, null: false
    t.text "breakfast"
    t.text "lunch"
    t.text "dinner"
    t.text "snack"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id", "planned_on"], name: "index_camp_kitchen_day_plans_on_camp_team_id_and_planned_on", unique: true
    t.index ["camp_team_id"], name: "index_camp_kitchen_day_plans_on_camp_team_id"
  end

  create_table "camp_program_blocks", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.string "title", null: false
    t.integer "starts_at_minutes", null: false
    t.integer "position", default: 0, null: false
    t.boolean "visible_to_others", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color", default: "blue", null: false
    t.index ["camp_team_id"], name: "index_camp_program_blocks_on_camp_team_id"
  end

  create_table "camp_program_week_blocks", force: :cascade do |t|
    t.bigint "camp_program_week_day_id", null: false
    t.string "title", null: false
    t.integer "starts_at_minutes", null: false
    t.integer "position", default: 0, null: false
    t.boolean "visible_to_others", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color", default: "blue", null: false
    t.index ["camp_program_week_day_id"], name: "index_camp_program_week_blocks_on_camp_program_week_day_id"
  end

  create_table "camp_program_week_days", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.string "day_key", null: false
    t.string "mode", default: "default_plan", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "planned_on"
    t.string "label"
    t.index ["camp_team_id", "planned_on"], name: "index_camp_program_week_days_on_camp_team_id_and_planned_on", unique: true
    t.index ["camp_team_id"], name: "index_camp_program_week_days_on_camp_team_id"
  end

  create_table "camp_room_people", force: :cascade do |t|
    t.bigint "camp_id", null: false
    t.string "name", null: false
    t.string "kind", null: false
    t.text "notes"
    t.bigint "camp_sleeping_place_id"
    t.bigint "related_camp_application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_id"], name: "index_camp_room_people_on_camp_id"
    t.index ["camp_sleeping_place_id"], name: "index_camp_room_people_on_camp_sleeping_place_id"
    t.index ["related_camp_application_id"], name: "index_camp_room_people_on_related_camp_application_id"
  end

  create_table "camp_sleeping_places", force: :cascade do |t|
    t.bigint "camp_id", null: false
    t.string "name", null: false
    t.integer "capacity", default: 1, null: false
    t.string "details"
    t.integer "position", default: 0, null: false
    t.boolean "custom", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_id", "name"], name: "index_camp_sleeping_places_on_camp_id_and_name", unique: true
    t.index ["camp_id"], name: "index_camp_sleeping_places_on_camp_id"
  end

  create_table "camp_sport_day_plans", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.date "planned_on", null: false
    t.integer "position", default: 0, null: false
    t.text "free_sport"
    t.text "required_sport"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id", "planned_on"], name: "index_camp_sport_day_plans_on_camp_team_id_and_planned_on", unique: true
    t.index ["camp_team_id"], name: "index_camp_sport_day_plans_on_camp_team_id"
  end

  create_table "camp_sport_material_changes", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.bigint "user_id"
    t.string "actor_name", default: "", null: false
    t.string "material_name", null: false
    t.string "change_type", null: false
    t.text "change_summary", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id", "created_at"], name: "index_camp_sport_material_changes_on_team_and_created_at"
    t.index ["camp_team_id"], name: "index_camp_sport_material_changes_on_camp_team_id"
    t.index ["user_id"], name: "index_camp_sport_material_changes_on_user_id"
  end

  create_table "camp_sport_material_items", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.string "name", null: false
    t.string "quantity", default: "", null: false
    t.string "storage_location", default: "", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id", "position"], name: "index_camp_sport_materials_on_team_and_position"
    t.index ["camp_team_id"], name: "index_camp_sport_material_items_on_camp_team_id"
  end

  create_table "camp_sport_tournament_plans", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.integer "start_time_minutes", default: 900, null: false
    t.integer "round_interval_minutes", default: 15, null: false
    t.string "round_note", default: "10 min Spiel, 5 min Wechsel", null: false
    t.string "group1_name"
    t.string "group2_name"
    t.string "group3_name"
    t.string "group4_name"
    t.string "group5_name"
    t.string "station1_name"
    t.string "station2_name"
    t.string "station3_name"
    t.string "station4_name"
    t.string "station5_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id"], name: "index_camp_sport_tournament_plans_on_camp_team_id", unique: true
  end

  create_table "camp_team_links", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id"], name: "index_camp_team_links_on_camp_team_id"
  end

  create_table "camp_team_shopping_items", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.string "name", null: false
    t.string "quantity"
    t.text "notes"
    t.boolean "purchased", default: false, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id"], name: "index_camp_team_shopping_items_on_camp_team_id"
  end

  create_table "camp_team_todos", force: :cascade do |t|
    t.bigint "camp_team_id", null: false
    t.string "title", null: false
    t.boolean "completed", default: false, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id"], name: "index_camp_team_todos_on_camp_team_id"
  end

  create_table "camp_teams", force: :cascade do |t|
    t.bigint "camp_id", null: false
    t.string "name", null: false
    t.integer "capacity", default: 0, null: false
    t.integer "male_slots", default: 0, null: false
    t.integer "female_slots", default: 0, null: false
    t.integer "responsible_slots", default: 0, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_template_id"
    t.datetime "next_internal_meeting_at"
    t.boolean "week_plan_published", default: false, null: false
    t.text "custom_description"
    t.text "custom_responsible_description"
    t.index ["camp_id", "name"], name: "index_camp_teams_on_camp_id_and_name", unique: true
    t.index ["camp_id"], name: "index_camp_teams_on_camp_id"
    t.index ["team_template_id"], name: "index_camp_teams_on_team_template_id"
  end

  create_table "camps", force: :cascade do |t|
    t.string "name"
    t.bigint "year_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_on"
    t.date "end_on"
    t.index ["year_id"], name: "index_camps_on_year_id"
  end

  create_table "download_items", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "scope_kind", default: 0, null: false
    t.bigint "team_template_id"
    t.bigint "camp_team_id"
    t.bigint "uploader_id"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["camp_team_id"], name: "index_download_items_on_camp_team_id"
    t.index ["scope_kind", "position"], name: "idx_download_items_on_scope_and_position"
    t.index ["team_template_id"], name: "index_download_items_on_team_template_id"
    t.index ["uploader_id"], name: "index_download_items_on_uploader_id"
  end

  create_table "medical_supply_changes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "actor_name", default: "", null: false
    t.string "item_name", null: false
    t.string "change_type", null: false
    t.text "change_summary", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_medical_supply_changes_on_created_at"
    t.index ["user_id"], name: "index_medical_supply_changes_on_user_id"
  end

  create_table "medical_supply_items", force: :cascade do |t|
    t.string "category", null: false
    t.string "usage_purpose", default: "", null: false
    t.string "name", null: false
    t.string "quantity", default: "", null: false
    t.string "expires_on_label", default: "", null: false
    t.text "notes", default: "", null: false
    t.boolean "missing", default: false, null: false
    t.boolean "opened", default: false, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category", "position"], name: "idx_med_supply_items_on_category_and_position"
  end

  create_table "team_template_links", force: :cascade do |t|
    t.bigint "team_template_id", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_template_id"], name: "index_team_template_links_on_team_template_id"
  end

  create_table "team_template_sport_material_changes", force: :cascade do |t|
    t.bigint "team_template_id", null: false
    t.bigint "user_id"
    t.string "actor_name", default: "", null: false
    t.string "material_name", null: false
    t.string "change_type", null: false
    t.text "change_summary", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_template_id", "created_at"], name: "idx_tt_sport_material_changes_on_template_and_created_at"
    t.index ["team_template_id"], name: "index_team_template_sport_material_changes_on_team_template_id"
    t.index ["user_id"], name: "index_team_template_sport_material_changes_on_user_id"
  end

  create_table "team_template_sport_material_items", force: :cascade do |t|
    t.bigint "team_template_id", null: false
    t.string "name", null: false
    t.string "quantity", default: "", null: false
    t.string "storage_location", default: "", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["team_template_id", "position"], name: "index_template_sport_materials_on_template_and_position"
    t.index ["team_template_id"], name: "index_team_template_sport_material_items_on_team_template_id"
  end

  create_table "team_templates", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "responsible_description"
    t.index ["name"], name: "index_team_templates_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "gender"
    t.date "birthdate"
    t.string "phone"
    t.boolean "first_aider", default: false
    t.boolean "sound_tech", default: false
    t.string "instruments"
    t.string "other_skills"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "years", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "registration_open", default: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "camp_application_choices", "camp_applications"
  add_foreign_key "camp_application_choices", "camps"
  add_foreign_key "camp_applications", "camp_sleeping_places"
  add_foreign_key "camp_applications", "camp_teams", column: "assigned_camp_team_id"
  add_foreign_key "camp_applications", "camps", column: "assigned_camp_id"
  add_foreign_key "camp_applications", "users"
  add_foreign_key "camp_applications", "years"
  add_foreign_key "camp_diy_day_plans", "camp_teams"
  add_foreign_key "camp_kitchen_day_plans", "camp_teams"
  add_foreign_key "camp_program_blocks", "camp_teams"
  add_foreign_key "camp_program_week_blocks", "camp_program_week_days"
  add_foreign_key "camp_program_week_days", "camp_teams"
  add_foreign_key "camp_room_people", "camp_applications", column: "related_camp_application_id"
  add_foreign_key "camp_room_people", "camp_sleeping_places"
  add_foreign_key "camp_room_people", "camps"
  add_foreign_key "camp_sleeping_places", "camps"
  add_foreign_key "camp_sport_day_plans", "camp_teams"
  add_foreign_key "camp_sport_material_changes", "camp_teams"
  add_foreign_key "camp_sport_material_changes", "users"
  add_foreign_key "camp_sport_material_items", "camp_teams"
  add_foreign_key "camp_sport_tournament_plans", "camp_teams"
  add_foreign_key "camp_team_links", "camp_teams"
  add_foreign_key "camp_team_shopping_items", "camp_teams"
  add_foreign_key "camp_team_todos", "camp_teams"
  add_foreign_key "camp_teams", "camps"
  add_foreign_key "camp_teams", "team_templates"
  add_foreign_key "camps", "years"
  add_foreign_key "download_items", "camp_teams"
  add_foreign_key "download_items", "team_templates"
  add_foreign_key "download_items", "users", column: "uploader_id"
  add_foreign_key "medical_supply_changes", "users"
  add_foreign_key "team_template_links", "team_templates"
  add_foreign_key "team_template_sport_material_changes", "team_templates"
  add_foreign_key "team_template_sport_material_changes", "users"
  add_foreign_key "team_template_sport_material_items", "team_templates"
end
