source 'https://rubygems.org'
ruby '2.3.3'

gem 'rails', '~> 4.2.6'
gem 'rails_12factor'
# Use Postgresql as the database for Active Record
gem 'pg'

gem 'haml'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'mini_magick', '~> 3.6.0'
gem 'nokogiri'
gem 'whenever'

gem 'browser'
gem 'ckeditor_rails'
gem 'formtastic', '~>2.3.0'
gem 'foundation-rails', '~> 6.3.1.0'
gem 'i18n'
gem 'mail'
gem 'modernizr-rails'
gem 'paperclip'
gem 'responders', '~> 2.0'
gem 'therubyracer', platforms: :ruby
gem 'videojs_rails'
# records crashes
gem 'raygun4ruby'

# pagination
gem 'will_paginate'

# logins
gem 'devise'

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

  gem 'rubocop', '~> 0.47.0', require: false

  # catches email sending, and logs instead
  gem 'letter_opener'

  # scans code for silly mistakes
  gem 'brakeman'

  # reruns the specs on code change
  gem 'rerun'

  # factories
  gem 'factory_girl_rails'

  # For real looking data in tests
  gem 'faker'
end

group :test do
  gem "codeclimate-test-reporter", "~> 1.0.0"
end

group :staging, :production do
  gem 'unicorn'
end
