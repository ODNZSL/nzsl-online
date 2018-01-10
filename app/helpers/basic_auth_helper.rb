# frozen_string_literal: true

module BasicAuthHelper
  def staging_env?
    Rails.env.production? && ENV['HEROKU_STAGING'] == 'YES'
  end
end
