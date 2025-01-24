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

ActiveRecord::Schema[8.0].define(version: 2025_01_22_010507) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "document", default: "", null: false
    t.string "legal_name", default: "", null: false
    t.string "trade_name", default: "", null: false
    t.date "founding_date"
    t.string "email", default: ""
    t.integer "business_type", default: 0
    t.string "main_activity", default: ""
    t.string "website", default: ""
    t.datetime "deleted_at"
    t.string "sms_hash", default: ""
    t.string "email_hash", default: ""
    t.datetime "token_sent_at"
    t.integer "token_failed_attempts", default: 0
    t.uuid "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_type"], name: "index_companies_on_business_type"
    t.index ["customer_id"], name: "index_companies_on_customer_id"
    t.index ["deleted_at"], name: "index_companies_on_deleted_at"
    t.index ["document"], name: "index_companies_on_document", unique: true
    t.index ["email"], name: "index_companies_on_email"
    t.index ["email_hash"], name: "index_companies_on_email_hash"
    t.index ["founding_date"], name: "index_companies_on_founding_date"
    t.index ["legal_name"], name: "index_companies_on_legal_name"
    t.index ["main_activity"], name: "index_companies_on_main_activity"
    t.index ["sms_hash"], name: "index_companies_on_sms_hash"
    t.index ["token_failed_attempts"], name: "index_companies_on_token_failed_attempts"
    t.index ["token_sent_at"], name: "index_companies_on_token_sent_at"
    t.index ["trade_name"], name: "index_companies_on_trade_name"
    t.index ["website"], name: "index_companies_on_website"
  end

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

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.integer "status", default: 0
    t.datetime "deleted_at"
    t.uuid "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_roles_on_company_id"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["key"], name: "index_roles_on_key"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["status"], name: "index_roles_on_status"
  end

  create_table "user_company_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "company_id", null: false
    t.uuid "role_id", null: false
    t.boolean "current", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_user_company_roles_on_company_id"
    t.index ["current"], name: "index_user_company_roles_on_current"
    t.index ["role_id"], name: "index_user_company_roles_on_role_id"
    t.index ["user_id"], name: "index_user_company_roles_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.datetime "deleted_at"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.boolean "confirmed", default: false
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "password_changed_at"
    t.integer "login_failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.boolean "locked", default: false
    t.integer "partner_type", default: 0
    t.string "mother_name"
    t.date "birth_date"
    t.string "document"
    t.integer "token_failed_attempts", default: 0
    t.integer "transaction_failed_attempts", default: 0
    t.string "sms_hash"
    t.string "email_hash"
    t.string "transaction_hash"
    t.datetime "token_sent_at"
    t.boolean "otp_required", default: false, null: false
    t.string "otp_secret"
    t.uuid "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["birth_date"], name: "index_users_on_birth_date"
    t.index ["confirmation_sent_at"], name: "index_users_on_confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["confirmed"], name: "index_users_on_confirmed"
    t.index ["customer_id"], name: "index_users_on_customer_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["document"], name: "index_users_on_document", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["email_hash"], name: "index_users_on_email_hash"
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["locked"], name: "index_users_on_locked"
    t.index ["locked_at"], name: "index_users_on_locked_at"
    t.index ["login_failed_attempts"], name: "index_users_on_login_failed_attempts"
    t.index ["mother_name"], name: "index_users_on_mother_name"
    t.index ["otp_required"], name: "index_users_on_otp_required"
    t.index ["otp_secret"], name: "index_users_on_otp_secret"
    t.index ["partner_type"], name: "index_users_on_partner_type"
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at"
    t.index ["password_digest"], name: "index_users_on_password_digest"
    t.index ["reset_password_sent_at"], name: "index_users_on_reset_password_sent_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sms_hash"], name: "index_users_on_sms_hash"
    t.index ["token_failed_attempts"], name: "index_users_on_token_failed_attempts"
    t.index ["token_sent_at"], name: "index_users_on_token_sent_at"
    t.index ["transaction_failed_attempts"], name: "index_users_on_transaction_failed_attempts"
    t.index ["transaction_hash"], name: "index_users_on_transaction_hash"
  end

  add_foreign_key "companies", "customers"
  add_foreign_key "customers", "plans"
  add_foreign_key "roles", "companies"
  add_foreign_key "user_company_roles", "companies"
  add_foreign_key "user_company_roles", "roles"
  add_foreign_key "user_company_roles", "users"
  add_foreign_key "users", "customers"
end
