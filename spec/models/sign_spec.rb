require 'spec_helper'

describe 'Sign' do
  it 'must create a new Sign object' do
    sign = Sign.new
    expect(sign.is_a?(Sign)).to eq(true)
  end

  it 'saves a new sign' do
    sign = Sign.new
    expect(sign.is_a?(Sign)).to eq(true)
    # TODO: test passing data into initalizing
  end

  it 'retrieves two random signs' do
    signOne = Sign.random
    signTwo = Sign.random
    expect(signOne.is_a?(Sign)).to eq(true)
    expect(signTwo.is_a?(Sign)).to eq(true)
    expect(signOne.id).not_to eq(signTwo.id)
  end

  it 'finds a sign' do
    sign = Sign.first(id: 1000)
    expect(sign.is_a?(Sign)).to eq(true)
  end

  it 'must have set class attributes' do
    expect(SIGN_URL.match(/\Ahttp\:/).is_a?(MatchData)).to eq(true)
    expect(ASSET_URL.match(/\Ahttp\:/).is_a?(MatchData)).to eq(true)
  end

  it 'must have all attributes of a Sign' do
    # As per the spec'd requirements of DNZSL:
    required_attributes = [
      :id,
      :gloss_main,
      :gloss_secondary,
      :gloss_minor,
      :gloss_maori,
      :word_classes,
      :inflection,
      :age_groups,
      :gender_groups,
      :video,
      :drawing,
      :usage_notes,
      :contains_numbers,
      :is_fingerspelling,
      :is_directional,
      :is_locatable
    ]
    sign = Sign.new
    required_attributes.each do |att|
      expect(sign.respond_to?(att)).to eq(true)
      expect(sign.respond_to?(att.to_s + '=', '')).to eq(true)
    end
  end

  it 'must find a single Sign with a simple search string' do
    # TODO: fix this test
    # params = {

    # }
    # search_result = Sign.search(params)
    # puts search_result
    # expect(search_result).to eq(true)
  end

  it 'must not throw errors' do
    # call the classmethods
    Sign.usage_tags
    Sign.topic_tags
    Sign.locations
    Sign.location_groups
    # TODO: check returned result
  end
end
