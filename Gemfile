# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.4'

gem 'rails', '~> 5.2.3'

# Use Postgresql as the database for Active Record
gem 'pg', '~>1.1'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'haml'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'lograge', '~> 0.11.2'
gem 'mini_magick', '~> 4.9.5'
gem 'nokogiri', '~> 1.10.4'
gem 'pandoc-ruby'
gem 'whenever'

gem 'autoprefixer-rails'
gem 'browser'
gem 'ckeditor_rails'
gem 'dalli'
gem 'foundation-rails', '~> 6.5.3.0'
gem 'i18n'
gem 'mail'
gem 'mini_racer', platforms: :ruby
gem 'modernizr-rails'
gem 'newrelic_rpm'
gem 'puma', '~> 4.2'
gem 'rack-canonical-host', '~> 0.2.3'

# For attaching files on the feedback form
# on Feedback model
gem 'paperclip'

gem 'responders', '~> 3.0'
gem 'videojs_rails'

# records crashes
gem 'raygun4ruby'

# pagination
gem 'will_paginate'

# Rest/http library
gem 'faraday'
gem 'faraday_middleware'

# logins
gem 'devise'

# Application performance monitoring
gem 'skylight'

group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'uglifier'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'

  # for debugging
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rb-readline'
  gem 'simplecov', require: false

  # for checking images in specs
  gem 'fastimage'

  ##
  # We want to use the same version of rubocop as Codeclimate does - see
  # .codeclimate.yml and https://docs.codeclimate.com/docs/rubocop
  gem 'rubocop', '~> 0.75.0', require: false
  gem 'rubocop-performance'

  # catches email sending, and logs instead
  gem 'letter_opener'

  # scans code for silly mistakes
  gem 'brakeman'

  # reruns the specs on code change
  gem 'rerun'

  # factories
  gem 'factory_bot_rails'

  # For real looking data in tests
  gem 'faker'
end

group :development do
  gem 'bundle-audit', require: false
  gem 'listen'
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'capybara-selenium'
  gem 'codeclimate-test-reporter', '~> 1.0.9'
  gem 'database_cleaner'
  gem 'percy-capybara', '~> 4.1.1'
  gem 'rails-controller-testing'
  gem 'webdrivers'
end

group :staging, :production do
  gem 'rails_12factor'
end
