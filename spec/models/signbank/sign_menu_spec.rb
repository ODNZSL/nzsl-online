require 'rails_helper'

RSpec.describe Signbank::SignMenu, type: :model do
  it 'has the same menu collections as Freelex::SignMenu' do
    expect(Signbank::SignMenu.locations).to eq Freelex::SignMenu.locations
    expect(Signbank::SignMenu.handshapes).to eq Freelex::SignMenu.handshapes
    expect(Signbank::SignMenu.location_groups).to eq Freelex::SignMenu.location_groups
  end

  describe '.topic_tags' do
    it 'maps Signbank topic records' do
      expected_topic_map = Signbank::Topic.pluck(:name, :name)
      expect(Signbank::SignMenu.topic_tags).to match_array expected_topic_map
    end
  end

  describe '.usage_tags' do
    it 'maps Signbank usage records' do
      expected_usage_map = Signbank::Sign.distinct.pluck(:usage, :usage).sort
      expect(Signbank::SignMenu.usage_tags).to match_array expected_usage_map
    end
  end
end
