# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    sign_id { 1235 } # this is in an external database
    vocab_sheet
    name { 'hello' }
    position { 1 }
    drawing { 'hello.png' }
    maori_name { 'tena koe' }
  end
end
