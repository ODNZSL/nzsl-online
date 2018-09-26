# frozen_string_literal: true

every 1.day, at: '3:00 am' do
  rails 'sign_images:refresh_cache'
end
