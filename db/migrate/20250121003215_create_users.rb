# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    return if table_exists? 'users'
    create_table :users, id: :uuid do |t|
      # Basic user information
      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.string :email, null: false, default: ""
      t.string :password_digest, null: false, default: ""
      t.datetime :deleted_at

      # Confirmation user
      t.datetime :confirmation_sent_at
      t.string :confirmation_token
      t.boolean :confirmed, default: false

      # Reset password
      t.datetime :reset_password_sent_at
      t.string :reset_password_token
      t.datetime :password_changed_at

      # Lockable
      t.integer  :login_failed_attempts, null: false, default: 0
      t.datetime :locked_at
      t.boolean :locked, default: false

      ## Extra information for account creation
      t.integer :partner_type, default: 0
      t.string :mother_name
      t.date :birth_date
      t.string :document
      t.integer :token_failed_attempts, default: 0
      t.integer :transaction_failed_attempts, default: 0
      t.string :sms_hash
      t.string :email_hash
      t.string :transaction_hash
      t.datetime :token_sent_at
      t.boolean :otp_required, null: false, default: false
      t.string :otp_secret

      t.references :customer, null: false, foreign_key: true, type: :uuid, index: true

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :document, unique: true
    add_index :users, :password_digest
    add_index :users, :reset_password_sent_at
    add_index :users, :password_changed_at
    add_index :users, :confirmed
    add_index :users, :confirmation_sent_at
    add_index :users, :login_failed_attempts
    add_index :users, :locked_at
    add_index :users, :locked
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :partner_type
    add_index :users, :deleted_at
    add_index :users, :mother_name
    add_index :users, :birth_date
    add_index :users, :token_failed_attempts
    add_index :users, :transaction_failed_attempts
    add_index :users, :sms_hash
    add_index :users, :email_hash
    add_index :users, :transaction_hash
    add_index :users, :token_sent_at
    add_index :users, :otp_required
    add_index :users, :otp_secret
  end
end
