# frozen_string_literal: true

RailsCloudflareTurnstile.configure do |config|
  config.site_key = ENV.fetch("TURNSTILE_SITE_KEY", "1x00000000000000000000AA")
  config.secret_key = ENV.fetch("TURNSTILE_SECRET_KEY", "1x0000000000000000000000000000000AA")
  config.enabled = Rails.env.production?
end
