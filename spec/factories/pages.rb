# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    title { Faker::Book.title }
    template 'standard'
    slug { Faker::Lorem.unique.word }
    label { Faker::Book.title }
    show_in_nav true
  end
end
