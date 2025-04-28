module Signbank
  class Record < ApplicationRecord
    self.abstract_class = true

    establish_connection "sqlite3://#{Rails.root.join('db', 'dictionary.sqlite3')}"

    # Signbank data should never be mutated, but when we run tests we need
    # to create test records
    after_initialize { readonly! unless Rails.env.test? }

    def self.database_version
      connection.execute('PRAGMA user_version').first['user_version']
    end

    ##
    # Useful for testing - related Signbank records don't have primary keys,
    # so in this case we consider them equal if they are the same type and
    # have the same attributes
    def ==(other)
      return super if self.class.primary_key.present?

      other.instance_of?(self.class) &&
        other.attributes == attributes
    end
  end
end
