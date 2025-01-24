# frozen_string_literal: true

class CreateUserCompanyRoles < ActiveRecord::Migration[8.0]
  def change
    return if table_exists? "user_company_roles"
    create_table :user_company_roles, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: true
      t.references :company, null: false, foreign_key: true, type: :uuid, index: true
      t.references :role, null: false, foreign_key: true, type: :uuid, index: true
      t.boolean :current, default: false, index: true

      t.timestamps
    end
  end
end
