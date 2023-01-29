require 'rails_helper'

RSpec.describe Signbank::Example, type: :model do
  it { expect(described_class.superclass).to eq Signbank::Record }

  describe '.scoped' do
    it 'is ordered by display_order' do
      sign = Signbank::Sign.create!(id: SecureRandom.uuid)
      Signbank::Example.create!(sign:, display_order: '2', video: '/test.mp4')
      Signbank::Example.create!(sign:, display_order: '1', video: '/test.mp4')
      expect(sign.examples.pluck(:display_order)).to eq %w[1 2]
    end

    it 'excludes an example without a video' do
      sign = Signbank::Sign.create!(id: SecureRandom.uuid)
      Signbank::Example.create!(sign:)
      expect(sign.examples).to be_empty
    end
  end
end
