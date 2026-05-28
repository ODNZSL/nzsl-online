# frozen_string_literal: true

require 'csv'

if Rails.env.local?
 SeedDataService.load_all
 end
