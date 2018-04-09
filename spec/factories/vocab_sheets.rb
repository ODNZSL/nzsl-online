# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :vocab_sheet do
    name { Faker::App.name }
  end
end
