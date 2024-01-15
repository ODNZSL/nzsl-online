require 'rails_helper'

module Signbank
  RSpec.describe Sign, type: :model do
    it { expect(described_class.superclass).to eq Signbank::Record }

    describe '#picture_url' do
      it 'delegates to assets of type image' do
        sign = Sign.create!(id: SecureRandom.uuid)

        expect do
          Asset.create!(sign:, filename: 'test.png', url: '/test.png')
          sign.reload
        end.to change(sign, :picture_url).from(nil).to('/test.png')
      end
    end

    describe 'aliases' do
      it 'alises gloss_main to gloss' do
        sign = Sign.new
        sign.gloss = 'Test'
        expect(sign.gloss_main).to eq sign.gloss
      end

      it 'aliases gloss_secondary to minor' do
        sign = Sign.new
        sign.minor = 'Test'
        expect(sign.gloss_secondary).to eq sign.minor
      end

      it 'aliases gloss_maori to maori' do
        sign = Sign.new
        sign.maori = 'Test'
        expect(sign.gloss_maori).to eq sign.maori
      end

      it 'alises borrowed_from to related_to' do
        sign = Sign.new
        sign.related_to = 'Test'
        expect(sign.borrowed_from).to eq sign.related_to
      end
    end

    describe '.safe_for_work' do
      it 'includes a regular sign' do
        topic = Signbank::Topic.find_by!(name: 'Animals')
        sign = Signbank::Sign.create!(id: SecureRandom.uuid, topics: [topic])
        expect(described_class.safe_for_work).to include sign
      end

      it 'includes a sign without topics' do
        sign = Signbank::Sign.create!(id: SecureRandom.uuid, topics: [])
        expect(described_class.safe_for_work).to include sign
      end

      it 'excludes an obscene sign' do
        sign = Signbank::Sign.create!(id: SecureRandom.uuid, usage: 'obscene')
        expect(described_class.safe_for_work).not_to include sign
      end

      it "excludes a sign with topic 'Sex and sexuality'" do
        topic = Signbank::Topic.find_by!(name: 'Sex and sexuality')
        sign = Signbank::Sign.create!(id: SecureRandom.uuid, topics: [topic])
        expect(described_class.safe_for_work).not_to include sign
      end

      it "excludes a sign with topic 'Sex and sexuality', and other topics" do
        topics = [
          Signbank::Topic.find_by!(name: 'Sex and sexuality'),
          Signbank::Topic.find_by!(name: 'Animals')
        ]
        sign = Signbank::Sign.create!(id: SecureRandom.uuid, topics:)
        expect(described_class.safe_for_work).not_to include sign
      end

      it "excludes a sign that is obscene AND has topic 'Sex and sexuality'" do
        topic = Signbank::Topic.find_by!(name: 'Sex and sexuality')
        sign = Signbank::Sign.create!(id: SecureRandom.uuid, usage: 'obscene', topics: [topic])
        expect(described_class.safe_for_work).not_to include sign
      end
    end

    describe '#location' do
      it 'reformats locations to replace dashes with full stop characters' do
        sign = Sign.new
        sign.location = '01 - In Front of Face'
        expect(sign.location).to eq '01.In Front of Face'
      end
    end

    describe '#random' do
      it 'returns a random sign each time it is called' do
        sign_1 = described_class.random
        sign_2 = described_class.random
        expect(sign_1).not_to eq sign_2
      end

      it 'requests only safe for work signs' do
        expect(described_class).to receive(:safe_for_work).and_call_original
        described_class.random
      end
    end
  end

  describe '#url' do
    it 'uses Signbank::AssetURL' do
      double = instance_double(Signbank::AssetURL, url: URI.parse('/test.png'))
      allow(Signbank::AssetURL).to receive(:new).and_return(double)
      sign = Signbank::Sign.new(video: 'test.png')
      expect(sign.video).to eq '/test.png'
    end

    it 'is nil when the URL is nil' do
      sign = Signbank::Sign.new(video: nil)
      expect(sign.video).to be_nil
    end

    it 'is nil when the URL is blank' do
      sign = Signbank::Sign.new(video: "")
      expect(sign.video).to be_nil
    end
  end
end
