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
    it 'returns a Sign' do
      expect(Sign.random).to be_an_instance_of(Sign)
    end
  end

  describe '.sign_of_the_day' do
    it 'returns a Sign' do
      expect(Sign.sign_of_the_day).to be_an_instance_of(Sign)
    end

    it 'returns the same sign when called repeatedly' do
      expect(Sign.sign_of_the_day.id).to eq(Sign.sign_of_the_day.id)
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
