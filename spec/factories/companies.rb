# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    document { Faker::Company.brazilian_company_number }
    legal_name { Faker::Company.name }
    trade_name { Faker::Company.name }
    founding_date { Faker::Date.between(from: '2014-09-23', to: '2024-09-25') }
    business_type { :LTDA }
    main_activity { "455677" }
    email { Faker::Internet.unique.email }
    account_validation { true }
    customer
  end
end
