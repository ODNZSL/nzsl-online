# frozen_string_literal: true

RailsCloudflareTurnstile.configure do |config|
  config.site_key = ENV['TURNSTILE_SITE_KEY']
  config.secret_key = ENV['TURNSTILE_SECRET_KEY']
end
