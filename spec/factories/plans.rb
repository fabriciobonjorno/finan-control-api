# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    name { Faker::Company.buzzword }
    max_users { rand(1..99) }
    max_companies { rand(1..99) }
    plan_price { rand(1..999) }
    plan_type { [ :free, :monthly, :semi_annual, :annual ].sample }
    status { :active }
  end
end
