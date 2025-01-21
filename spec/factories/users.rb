# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.email }
    password   { Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true) }
    confirmed  { false }
    customer

    trait :confirmed do
      confirmed { true }
    end

    trait :locked do
      locked { true }
      locked_at { Time.current }
    end

    trait :with_account_validation do
      account_validation { true }
      birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
      document { CPF.generate(true) }
    end
  end
end
