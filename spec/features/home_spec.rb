require 'rails_helper'
require 'percy'

describe 'Test with visual testing', type: :feature, js: true do
  let(:sign_id) { '1301' }
  # before {Timecop.freeze(Time.local(2019, 1, 1)) }
  # after { Timecop.return }

  before do
    SeedDataService.load_all
    allow(Sign).to receive(:random).and_return Sign.first(id: sign_id)
  end
  describe 'home' do
    it 'root_path' do
      # Make sure we have the same random sign,
      # so we don't get visual differences every run
      visit root_path
      Percy.snapshot(page, name: 'homepage')
    end
  end
end
