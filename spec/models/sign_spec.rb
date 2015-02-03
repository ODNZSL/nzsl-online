require 'spec_helper'

describe "Sign" do

  it 'should create a new Sign object' do
    sign = Sign.new
    sign.is_a?(Sign).should == true
  end

  it 'should have set class attributes' do
    
    SIGN_URL.match(/\Ahttp\:/).is_a?(MatchData).should == true
    ASSET_URL.match(/\Ahttp\:/).is_a?(MatchData).should == true
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
      sign.respond_to?(att).should == true
      sign.respond_to?(att.to_s + "=", "").should == true
    end
  end


  it 'should find a single Sign with a simple search string'

  it 'should find multiple Signs with a simple search string'

end

