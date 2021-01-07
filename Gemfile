# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version')

gem 'rails', '~> 6.0.3.4'

# Use Postgresql as the database for Active Record
gem 'pg', '~>1.2'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'haml'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'lograge', '~> 0.11.2'
gem 'mini_magick', '~> 4.11.0'
gem 'nokogiri', '~> 1.11.1'
gem 'pandoc-ruby'
gem 'whenever'

gem 'autoprefixer-rails'

# As of 2020-05-23, the Rails 6 compatible version of ckeditor_rails has not
# been released to Rubygems so we are instead referencing the commit where the
# master branch gained Rails 6 support but has the fewest other changes from
# the released version.
#
# It is our intention to revert to the official Rubygems version of the gem as
# soon as possible.
gem 'ckeditor_rails', git: 'https://github.com/tsechingho/ckeditor-rails.git', ref: 'dc5de031b0dfde527cf5571bb87b90c59ca24ab1'

gem 'dalli'
gem 'foundation-rails', '~> 6.6.2.0'
gem 'i18n'
gem 'mail'
gem 'mini_racer', platforms: :ruby
gem 'modernizr-rails'
gem 'puma', '~> 5.1'
gem 'rack-canonical-host', '~> 1.0.0'

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
gem 'newrelic_rpm'
gem 'skylight'

gem 'sassc-rails'
gem 'uglifier'

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
  gem 'rubocop', '~> 1.8.0', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false

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
  gem 'percy-capybara', '~> 4.3.2'
  gem 'rails-controller-testing'
  gem 'webdrivers'
end
