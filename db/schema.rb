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

ActiveRecord::Schema[8.0].define(version: 2025_01_20_223932) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "terms_accepted"
    t.datetime "terms_accepted_at"
    t.datetime "deleted_at"
    t.datetime "plan_start_date"
    t.datetime "plan_end_date"
    t.uuid "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_customers_on_deleted_at"
    t.index ["name"], name: "index_customers_on_name", unique: true
    t.index ["plan_end_date"], name: "index_customers_on_plan_end_date"
    t.index ["plan_id"], name: "index_customers_on_plan_id"
    t.index ["plan_start_date"], name: "index_customers_on_plan_start_date"
    t.index ["terms_accepted"], name: "index_customers_on_terms_accepted"
    t.index ["terms_accepted_at"], name: "index_customers_on_terms_accepted_at"
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "max_users", default: 0, null: false
    t.integer "max_companies", default: 0, null: false
    t.integer "plan_type", default: 0, null: false
    t.decimal "plan_price", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_plans_on_deleted_at"
    t.index ["max_companies"], name: "index_plans_on_max_companies"
    t.index ["max_users"], name: "index_plans_on_max_users"
    t.index ["name"], name: "index_plans_on_name"
    t.index ["plan_price"], name: "index_plans_on_plan_price"
    t.index ["plan_type"], name: "index_plans_on_plan_type"
    t.index ["status"], name: "index_plans_on_status"
  end

  add_foreign_key "customers", "plans"
end
