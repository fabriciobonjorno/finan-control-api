# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    return if table_exists? "plans"
    create_table :plans, id: :uuid do |t|
      t.string :name, null: false, default: ""
      t.integer :max_users, null: false, default: 0
      t.integer :max_companies, null: false, default: 0
      t.decimal :free_price, precision: 10, scale: 2, null: false, default: 0.00
      t.decimal :monthly_price, precision: 10, scale: 2, null: false, default: 0.00
      t.decimal :semi_annual_price, precision: 10, scale: 2, null: false, default: 0.00
      t.decimal :annual_price, precision: 10, scale: 2, null: false, default: 0.00
      t.integer :status, null: false, default: 0
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :plans, :name
    add_index :plans, :max_users
    add_index :plans, :max_companies
    add_index :plans, :free_price
    add_index :plans, :monthly_price
    add_index :plans, :semi_annual_price
    add_index :plans, :annual_price
    add_index :plans, :status
    add_index :plans, :deleted_at
  end
end
