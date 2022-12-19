module Signbank
  class SignOfTheDay
    CACHE_KEY = 'signbank-sign-of-the-day'.freeze
    EXPIRY = 24.hours

    def self.find
      Rails.cache.fetch(CACHE_KEY, expires_in: EXPIRY) do
        Sign.random
      end
    end
  end
end
