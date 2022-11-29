class Signbank::Record < ApplicationRecord
  establish_connection "sqlite3://#{Rails.root.join('db', 'dictionary.sqlite3')}"
end
