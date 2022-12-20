# frozen_string_literal: true

require 'rails_helper'

describe 'Topics', js: true do
  let(:sign_id) { '1301' }

  before do
    SeedDataService.load_all
    allow(SignModel.resolve).to receive(:random).and_return SignModel.resolve.find(sign_id)
  end

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
