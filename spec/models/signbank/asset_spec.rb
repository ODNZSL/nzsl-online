require 'rails_helper'

RSpec.describe Signbank::Asset, type: :model do
  it { expect(described_class.superclass).to eq Signbank::Record }

  describe '.image' do
    it 'includes a PNG file' do
      sign = Signbank::Sign.create!(id: SecureRandom.uuid)
      asset = Signbank::Asset.create!(filename: 'test.png', sign: sign)
      expect(Signbank::Asset.where(sign: sign).image).to eq [asset]
    end

    it 'excludes a MP4 file' do
      sign = Signbank::Sign.create!(id: SecureRandom.uuid)
      Signbank::Asset.create!(filename: 'test.mp4', sign: sign)
      expect(Signbank::Asset.where(sign: sign).image).to be_empty
    end
  end

  describe '.scoped' do
    it 'is ordered by display_order' do
      sign = Signbank::Sign.create!(id: SecureRandom.uuid)
      Signbank::Asset.create!(sign: sign, display_order: '2')
      Signbank::Asset.create!(sign: sign, display_order: '1')
      expect(sign.assets.pluck(:display_order)).to eq %w[1 2]
    end
  end
end
