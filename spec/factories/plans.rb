# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    name { Faker::Company.buzzword }
    max_users { rand(1..99) }
    max_companies { rand(1..99) }
    free_price { rand(1..999) }
    monthly_price { rand(1..999) }
    semi_annual_price { rand(1..999) }
    annual_price { rand(1..999) }
  end
end
