# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NzslOnline
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.app_domain_name = ENV['APP_DOMAIN_NAME']
    config.app_protocol = ENV['APP_PROTOCOL']
    config.base_url = "#{config.app_protocol}://#{config.app_domain_name}/"

    ##
    # This application has multiple DNS names for historical reasons. For SEO
    # and effective CDN caching purposes we want to have just one canonical DNS
    # name but we also cannot break existing links which might use the other
    # names.
    #
    # Traditionally this problem would be solved via URL rewriting in
    # Apache/Nginx/Varnish etc. but that is not possible because we are hosted
    # on Heroku.
    #
    # The `rack-canonical-host` middleware allows us to solve this problem in
    # Rails. It redirects requests for non-canonical domain names to the
    # canonical domain name.
    #
    # `Rack::Sendfile` is the first middleware in the Rails middleware stack
    # (run `bundle exec rails middleware` for details) so we are inserting the
    # Rack::CanonicalHost middleware right at the start. This means we don't
    # waste time processing a request which will be redirected by
    # Rack::CanonicalHost anyway.
    #
    # More details: https://github.com/tylerhunt/rack-canonical-host
    #
    if ENV['CANONICAL_HOST']
      config.middleware.insert_before(
        Rack::Sendfile,
        Rack::CanonicalHost,
        ENV['CANONICAL_HOST'],
        cache_control: 'max-age=3600'
      )
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
