# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    return if table_exists? "customers"
    create_table :customers, id: :uuid do |t|
      t.string :name
      t.boolean :terms_accepted
      t.datetime :terms_accepted_at
      t.datetime :deleted_at
      t.datetime :plan_start_date
      t.datetime :plan_end_date

      t.references :plan, null: false, foreign_key: true, type: :uuid, index: true

      t.timestamps
    end

    add_index :customers, :name, unique: true
    add_index :customers, :terms_accepted
    add_index :customers, :terms_accepted_at
    add_index :customers, :deleted_at
    add_index :customers, :plan_start_date
    add_index :customers, :plan_end_date
  end
end
