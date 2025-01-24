# frozen_string_literal: true

class UserCompanyRole < ApplicationRecord
  belongs_to :user
  belongs_to :company
  belongs_to :role

  validates :user_id, uniqueness: { scope: [ :company_id, :role_id ], message: "já possui este perfil nessa empresa" }
  validates :user, :company, :role, presence: true
end
