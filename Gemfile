if RUBY_VERSION =~ /1.9/
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8
end

source 'http://rubygems.org'

gem 'rails', '~> 4.2.0'
gem 'haml'
gem 'nokogiri'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'rdiscount', '~> 1.6.8'
gem 'mini_magick', '~> 3.4.0'
gem 'whenever'
gem 'formtastic', '~>2.3.0'
gem 'paperclip'
gem 'mail'
gem 'i18n'
gem 'sqlite3', '~> 1.3.10'
gem 'therubyracer', :platforms => :ruby
gem 'modernizr-rails'
gem 'ckeditor_rails'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end


# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
   gem 'rspec-rails', '~> 3.2.0'
   gem 'pry-rails'
   # gem 'debugger'
   gem 'capistrano'
   gem 'capistrano-ext'
   gem 'rvm-capistrano'
   gem 'simplecov', require: false
   gem 'rb-readline'

end

