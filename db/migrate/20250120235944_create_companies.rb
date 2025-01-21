# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    return if table_exists? "companies"
    create_table :companies, id: :uuid do |t|
      t.string :document, null: false, default: ""
      t.string :legal_name, null: false, default: ""
      t.string :trade_name, null: false, default: ""

      ## Extra information for account creation
      t.date :founding_date
      t.string :email, default: ""
      t.integer :business_type, default: 0
      t.string :main_activity, default: ""
      t.string :website, default: ""
      t.datetime :deleted_at
      t.string :sms_hash, default: ""
      t.string :email_hash, default: ""
      t.datetime :token_sent_at
      t.integer :token_failed_attempts, default: 0
      t.references :customer, null: false, foreign_key: true, type: :uuid, index: true

      t.timestamps
    end

    add_index :companies, :document, unique: true
    add_index :companies, :legal_name
    add_index :companies, :trade_name
    add_index :companies, :founding_date
    add_index :companies, :email
    add_index :companies, :business_type
    add_index :companies, :main_activity
    add_index :companies, :website
    add_index :companies, :deleted_at
    add_index :companies, :sms_hash
    add_index :companies, :email_hash
    add_index :companies, :token_sent_at
    add_index :companies, :token_failed_attempts
  end
end
