module Signbank
  class Record < ApplicationRecord
    establish_connection "sqlite3://#{Rails.root.join('db', 'dictionary.sqlite3')}"

    # Signbank data should never be mutated, but when we run tests we need
    # to create test records
    after_initialize { readonly! unless Rails.env.test? }
  end
end
