# frozen_string_literal: true

require 'csv'

SeedDataService.load_all if Rails.env.local? # rubocop:disable Rails/UnknownEnv
