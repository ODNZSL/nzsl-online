# frozen_string_literal: true

require 'rails_helper'

describe 'Topics', js: true, sign_model_adapter: :signbank do
  before { SeedDataService.load_all }

  describe 'Actions and Activities' do
    it 'works' do
      visit '/topics'
      click_on 'Actions and activities'

      expect(page).to have_css('.pagination_container')
      expect(page).to have_content('previous')
      expect(page).to have_content('next')
    end
  end
end
