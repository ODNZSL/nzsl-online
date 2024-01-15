require 'rails_helper'

RSpec.describe Signbank::AssetURL do
  describe '#url' do
    context 'when using S3Adapter' do
      let(:asset_url) { 'https://example.s3.amazonaws.com/assets/asset.mp4' }
      let(:adapter) { Signbank::AssetURL::S3Adapter }

      it 'returns the presigned URL for the asset' do
        asset = Signbank::AssetURL.new(asset_url, adapter:)
        presigned_url = 'https://s3.amazonaws.com/bucket-name/asset.mp4?expires=1234567890'

        allow(adapter).to receive(:configured?).and_return(true)
        allow(adapter).to receive(:client).and_return(instance_double(Aws::S3::Client))
        allow_any_instance_of(Aws::S3::Object).to receive(:presigned_url).and_return(presigned_url)

        expect(asset.url).to eq(URI.parse(presigned_url))
      end

      it 'returns nil if S3Adapter is not configured' do
        asset = Signbank::AssetURL.new(asset_url, adapter:)

        allow(adapter).to receive(:configured?).and_return(false)

        expect(asset.url).to be_nil
      end

      it 'raises an error if the URL does not have the expected hostname' do
        asset_url = 'https://example.com/assets/asset.mp4'
        asset = Signbank::AssetURL.new(asset_url, adapter:)
        allow(adapter).to receive(:configured?).and_return(true)

        expect { asset.url }.to raise_error(ArgumentError)
      end
    end

    context 'when using PassthroughUrlAdapter' do
      let(:asset_url) { URI.parse('https://example.com/assets/asset.mp4') }
      let(:adapter) { Signbank::AssetURL::PassthroughUrlAdapter }

      it 'returns the original asset URL' do
        asset = Signbank::AssetURL.new(asset_url.to_s, adapter:)

        allow(adapter).to receive(:configured?).and_return(true)

        expect(asset.url).to eq(asset_url)
      end
    end

    context 'when no adapter is specified' do
      let(:asset_url) { URI.parse('https://example.com/assets/asset.mp4') }

      it 'uses the first configured adapter' do
        asset = Signbank::AssetURL.new(asset_url.to_s)

        allow(Signbank::AssetURL::S3Adapter).to receive(:configured?).and_return(false)
        allow(Signbank::AssetURL::PassthroughUrlAdapter).to receive(:configured?).and_return(true)

        expect(asset.url).to eq(asset_url)
      end

      it 'returns nil if no adapter is configured' do
        asset = Signbank::AssetURL.new(asset_url.to_s)

        allow(Signbank::AssetURL::S3Adapter).to receive(:configured?).and_return(false)
        allow(Signbank::AssetURL::PassthroughUrlAdapter).to receive(:configured?).and_return(false)

        expect(asset.url).to be_nil
      end
    end
  end
end
