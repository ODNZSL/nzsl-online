release: bundle exec rails db:migrate
web: (bundle exec rails dictionary:update || true) && bundle exec puma -C config/puma.rb
