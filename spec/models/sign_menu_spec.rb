# frozen_string_literal: true

require 'rails_helper'

describe 'SignMenu' do
  it 'must not throw errors' do
    # call the classmethods
    SignMenu.usage_tags
    SignMenu.topic_tags
    SignMenu.locations
    SignMenu.location_groups
    # TODO: check returned result
  end
end
