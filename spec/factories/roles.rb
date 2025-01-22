# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { Faker::Job.position  }
    key { Faker::Job.position.downcase }
    status { 0 }
    company
  end
end
