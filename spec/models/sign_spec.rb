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

  describe '.first' do
    it 'finds a sign' do
      sign = Sign.first(id: 1000)
      expect(sign.is_a?(Sign)).to eq(true)
    end
  end

  describe '.random' do
    it 'retrieves two random signs' do
      sign_one = Sign.random
      sign_two = Sign.random
      expect(sign_one.is_a?(Sign)).to eq(true)
      expect(sign_two.is_a?(Sign)).to eq(true)
      expect(sign_one.id).not_to eq(sign_two.id)
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
