require 'rails_helper'

RSpec.describe Signbank::SignOfTheDay, type: :model do
  describe '#find' do
    it 'fetches a random sign to populate the cache for 24 hours' do
      expect(Signbank::Sign).to receive(:random)
      expect(Rails.cache).to receive(:fetch)
        .with(described_class::CACHE_KEY, expires_in: described_class::EXPIRY)
        .and_call_original
      described_class.find
    end
  end
end
