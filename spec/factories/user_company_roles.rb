# frozen_string_literal: true

FactoryBot.define do
  factory :user_company_role do
    user
    company
    role
  end
end
