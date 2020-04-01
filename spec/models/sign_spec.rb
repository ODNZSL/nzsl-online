# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign', type: :model do
  describe '.new' do
    it 'must create a new Sign object' do
      sign = Sign.new
      expect(sign.is_a?(Sign)).to eq(true)
    end
  end

  describe 'attributes' do
    it 'must have set class attributes' do
      expect(SIGN_URL.match(/\Ahttp\:/).is_a?(MatchData)).to eq(true) # rubocop:disable Performance/StartWith
      expect(ASSET_URL.match(/\Ahttp\:/).is_a?(MatchData)).to eq(true) # rubocop:disable Performance/StartWith
    end

    it 'must have all attributes of a Sign' do
      # As per the spec'd requirements of DNZSL:
      required_attributes = %i[
        id
        gloss_main
        gloss_secondary
        gloss_minor
        gloss_maori
        word_classes
        inflection
        age_groups
        gender_groups
        video
        drawing
        usage_notes
        contains_numbers
        is_fingerspelling
        is_directional
        is_locatable
      ]
      sign = Sign.new
      required_attributes.each do |att|
        expect(sign.respond_to?(att)).to eq(true)
        expect(sign.respond_to?(att.to_s + '=', '')).to eq(true)
      end
    end
  end

  describe '.from_json' do
    it 'returns nil if given JSON is obviously invalid' do
      expect(Sign.from_json(nil)).to eq(nil)
      expect(Sign.from_json('')).to eq(nil)

      # nil.to_json # => 'null'
      expect(Sign.from_json('null')).to eq(nil)
    end

    it 'creates a Sign with identical attributes from JSON outputted by Sign#to_json' do
      original_sign = Sign.first(id: 1000)
      original_sign_json = original_sign.to_json
      rehydrated_sign = Sign.from_json(original_sign_json)

      Sign::SIGN_ATTRIBUTES.each do |attr|
        expect(rehydrated_sign.send(attr)).to eq(original_sign.send(attr))
      end
    end
  end

  describe '.find_by_id_via_cache' do
    let(:sign_id) { 1234 }

    context 'when Rails cache is enabled' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      context 'when the Item caching feature is enabled' do
        before do
          allow(FeatureFlags::StoreVocabSheetItemsInRailsCache).to receive(:enabled?).and_return(true)
        end

        it 'caches the Sign as expected' do
          # given an empty cache
          expect(Rails.cache.exist?(sign_id)).to be(false)

          # when we create a new Sign from the given sign_id
          Sign.find_by_id_via_cache(sign_id)

          # then we expect the sign to be cached
          expect(Rails.cache.exist?(sign_id)).to be(true)

          # and we expect the cached JSON to be identical to the JSON generated
          # by calling `#to_json` on the sign fetched directly from Freelex
          sign_directly_from_freelex_json = Sign.first(id: sign_id).to_json
          cached_sign_json = Rails.cache.fetch(sign_id)
          expect(cached_sign_json).to eq(sign_directly_from_freelex_json)
        end

        it 'caches calls to Freelex when called repeatedly with the same input' do
          expect(Sign).to receive(:first).once.and_call_original

          Sign.find_by_id_via_cache(sign_id)
          Sign.find_by_id_via_cache(sign_id)
        end
      end

      context 'when the Item caching feature is disabled' do
        before do
          allow(FeatureFlags::StoreVocabSheetItemsInRailsCache).to receive(:enabled?).and_return(false)
        end

        it 'does not cache calls to Freelex when creating the same Sign repeatedly' do
          expect(Sign).to receive(:first).twice

          Sign.find_by_id_via_cache(sign_id)
          Sign.find_by_id_via_cache(sign_id)
        end
      end
    end
  end

  describe '.first' do
    it 'finds a sign' do
      sign = Sign.first(id: 1000)
      expect(sign.is_a?(Sign)).to eq(true)
    end
  end

  describe '.random' do
    it 'returns a Sign' do
      expect(Sign.random).to be_an_instance_of(Sign)
    end
  end

  describe '.sign_of_the_day' do
    it 'recovers if an exception is rasied by Rails caching' do
      # given we are not in dev|test env
      allow(Rails.env).to receive(:development?).and_return(false)
      allow(Rails.env).to receive(:test?).and_return(false)

      # and Rails caching raises and exception for some reason
      allow(Rails.cache).to receive(:fetch).and_raise(TypeError)

      # then we expect the method to still return a sign
      expect(Sign.sign_of_the_day).to be_an_instance_of(Sign)
    end

    context 'when caching is enabled' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it 'returns the same sign when called repeatedly' do
        expect(Sign.sign_of_the_day.id).to eq(Sign.sign_of_the_day.id)
      end
    end
  end

  describe '.paginate' do
    it 'must find a single Sign with a simple search string' do
      search_query = {
        's' => ['hello'],
        'hs' => [],
        'l' => [],
        'lg' => [],
        'tag' => [],
        'usage' => []
      }
      page_number = 1
      search_result = Sign.paginate(search_query, page_number)
      # we get at least one result
      expect(search_result.length).to be > 0
    end
  end
end
