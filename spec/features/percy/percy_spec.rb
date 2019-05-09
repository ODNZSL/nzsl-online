require 'rails_helper'
require 'percy'

describe 'Test with visual testing', type: :feature, js: true do
  let(:sign) { FactoryBot.create :sign }
  # before {Timecop.freeze(Time.local(2019, 1, 1)) }
  # after { Timecop.return }

  before { SeedDataService.load_all }

  # describe 'home' do
  #   it 'loads homepage' do
  #     visit root_path
  #     Percy.snapshot(page, name: "homepage")
  #   end
  # end

  describe 'signs' do
    it 'loads signs#show' do
      visit sign_path(id: '1301')
      Percy.snapshot(page, name: "signs#show")
    end
  end
end
