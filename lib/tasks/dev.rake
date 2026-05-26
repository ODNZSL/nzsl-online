# frozen_string_literal: true

namespace :dev do
  desc 'Seed the environment with some example data'
  task seed: :environment do
    require 'csv'
    SeedDataService.load_all
    puts 'Seed data loaded'
  end
end
