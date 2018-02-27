# frozen_string_literal: true

if Rails.env.production?
  Raygun.setup do |config|
    config.filter_parameters = Rails.application.config.filter_parameters

    if ENV['RAYGUN_APIKEY'].present?
      config.api_key = ENV['RAYGUN_APIKEY']
      config.enable_reporting = true
      config.affected_user_method = :current_user
    else
      config.enable_reporting = false
    end
  end
end
