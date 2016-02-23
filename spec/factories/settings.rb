# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    key { Faker::App.name }
    value { Faker::App.version }
  end
end
