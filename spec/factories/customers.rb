# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    name { Faker::Company.name }
    terms_accepted { true }
    terms_accepted_at { Time.now }
    plan
  end
end
