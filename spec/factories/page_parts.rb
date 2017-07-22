FactoryGirl.define do
  factory :page_part do
    title { Faker::Book.title }

    page(factory: :page)
  end
end
