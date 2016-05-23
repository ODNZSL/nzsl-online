# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vocab_sheet do
    name { Faker::App.name }
  end
end
