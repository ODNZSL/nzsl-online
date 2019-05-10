require 'rails_helper'
require 'percy'

describe 'Test with visual testing', type: :feature, js: true do
  let(:sign_id) { '1301' }
  before { SeedDataService.load_all }
  before { allow(Sign).to receive(:random).and_return Sign.first(id: sign_id) }

  describe 'signs' do
    describe 'signs#show' do
      before { visit sign_path(id: sign_id) }
      it { expect(page).to have_text 'goodbye, hello'}
      after { Percy.snapshot(page, name: "signs#show") }
    end
    it 'signs#search' do
      visit root_path
      fill_in :s, with: 'hello'
      click_button class: 'search-button'
      expect(page).to have_link 'goodbye, hello'
      Percy.snapshot(page, name: "signs#search")
    end
  end
end
