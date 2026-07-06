# frozen_string_literal: true

RailsCloudflareTurnstile.configure do |config|
  # fallback values are cloudflare test keys: https://developers.cloudflare.com/turnstile/troubleshooting/testing/
  config.site_key = ENV.fetch('TURNSTILE_SITE_KEY', '2x00000000000000000000AB')
  config.secret_key = ENV.fetch('TURNSTILE_SECRET_KEY', '2x0000000000000000000000000000000AA')
end
