# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :setting do
    key { 'help' }
    value { Faker::App.version }
  end
end
