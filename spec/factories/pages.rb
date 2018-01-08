# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :page do
    title { Faker::Book.title }
    template 'standard'
  end
end
