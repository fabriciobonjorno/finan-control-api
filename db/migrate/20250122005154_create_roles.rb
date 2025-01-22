# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    return if table_exists? "roles"
    create_table :roles, id: :uuid do |t|
      t.string :name
      t.string :key
      t.integer :status, default: 0
      t.datetime :deleted_at
      t.references :company, null: false, foreign_key: true, type: :uuid, index: true

      t.timestamps
    end

    add_index :roles, :name
    add_index :roles, :key
    add_index :roles, :status
    add_index :roles, :deleted_at
  end
end
