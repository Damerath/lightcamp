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

ActiveRecord::Schema[7.1].define(version: 2026_03_26_113000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["assigned_camp_id"], name: "index_camp_applications_on_assigned_camp_id"
    t.index ["assigned_camp_team_id"], name: "index_camp_applications_on_assigned_camp_team_id"
    t.index ["user_id"], name: "index_camp_applications_on_user_id"
    t.index ["year_id"], name: "index_camp_applications_on_year_id"
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
    t.index ["camp_id", "name"], name: "index_camp_teams_on_camp_id_and_name", unique: true
    t.index ["camp_id"], name: "index_camp_teams_on_camp_id"
  end

  create_table "camps", force: :cascade do |t|
    t.string "name"
    t.bigint "year_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year_id"], name: "index_camps_on_year_id"
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

  add_foreign_key "camp_application_choices", "camp_applications"
  add_foreign_key "camp_application_choices", "camps"
  add_foreign_key "camp_applications", "camp_teams", column: "assigned_camp_team_id"
  add_foreign_key "camp_applications", "camps", column: "assigned_camp_id"
  add_foreign_key "camp_applications", "users"
  add_foreign_key "camp_applications", "years"
  add_foreign_key "camp_teams", "camps"
  add_foreign_key "camps", "years"
end
