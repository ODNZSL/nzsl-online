require 'rails_helper'

RSpec.describe Signbank::SignMenu, type: :model do
  it 'must not throw errors' do
    # call the classmethods
    Signbank::SignMenu.usage_tags
    Signbank::SignMenu.topic_tags
    Signbank::SignMenu.locations
    Signbank::SignMenu.location_groups
    # TODO: check returned result
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
