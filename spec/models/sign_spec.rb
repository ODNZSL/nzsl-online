require 'spec_helper'

describe "Sign" do

  it 'should create a new Sign object' do
    sign = Sign.new
    expect(sign.is_a?(Sign)).to eq(true)
  end

  it 'should have set class attributes' do
    
    expect(SIGN_URL.match(/\Ahttp\:/).is_a?(MatchData)).to eq(true)
    expect(ASSET_URL.match(/\Ahttp\:/).is_a?(MatchData)).to eq(true)
  end

  it 'should have all attributes of a Sign' do
    #As per the spec'd requirements of DNZSL:
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
      expect(sign.respond_to?(att.to_s + "=", "")).to eq(true)
    end
  end


  it 'should find a single Sign with a simple search string'

  it 'should find multiple Signs with a simple search string'

end

