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

ActiveRecord::Schema[8.0].define(version: 2025_01_20_221639) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "max_users", default: 0, null: false
    t.integer "max_companies", default: 0, null: false
    t.decimal "free_price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "monthly_price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "semi_annual_price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "annual_price", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["annual_price"], name: "index_plans_on_annual_price"
    t.index ["deleted_at"], name: "index_plans_on_deleted_at"
    t.index ["free_price"], name: "index_plans_on_free_price"
    t.index ["max_companies"], name: "index_plans_on_max_companies"
    t.index ["max_users"], name: "index_plans_on_max_users"
    t.index ["monthly_price"], name: "index_plans_on_monthly_price"
    t.index ["name"], name: "index_plans_on_name"
    t.index ["semi_annual_price"], name: "index_plans_on_semi_annual_price"
    t.index ["status"], name: "index_plans_on_status"
  end
end
