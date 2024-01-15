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
      sign.reload
      expect(sign.examples).to be_empty
    end
  end

  describe '#video' do
    it 'uses Signbank::AssetURL' do
      double = instance_double(Signbank::AssetURL, url: URI.parse('/test.png'))
      allow(Signbank::AssetURL).to receive(:new).and_return(double)
      example = Signbank::Example.new(video: 'test.png')
      expect(example.video).to eq '/test.png'
    end

    it 'is nil when the URL is nil' do
      example = Signbank::Example.new(video: nil)
      expect(example.video).to be_nil
    end

    it 'is nil when the URL is blank' do
      example = Signbank::Example.new(video: '')
      expect(example.video).to be_nil
    end
  end
end
