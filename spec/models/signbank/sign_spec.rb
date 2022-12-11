require 'rails_helper'

module Signbank
  RSpec.describe Sign, type: :model do
    it { expect(described_class.superclass).to eq Signbank::Record }

    describe '#picture_url' do
      it 'delegates to assets of type image' do
        sign = Sign.create!(id: SecureRandom.uuid)

        expect do
          Asset.create!(sign: sign, filename: 'test.png', url: '/test.png')
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

    describe '#location' do
      it 'reformats locations to replace dashes with full stop characters' do
        sign = Sign.new
        sign.location = '01 - In Front of Face'
        expect(sign.location).to eq '01.In Front of Face'
      end
    end

    describe '#sign_of_the_day' do
      it 'fetches and caches a #random sign'
    end

    describe '#random' do
      it 'returns a random sign each time it is called'
      it "excludes signs in topic 'Sex and Sexuality'"
      it "excludes signs with 'obscene' usage"
    end
  end
end
