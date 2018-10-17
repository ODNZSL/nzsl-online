# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignsHelper, type: :helper do
  drawing_1 = "1234/a_test-default"

  describe '#convert_to_high_resolution' do
    context 'when provided with a "default" sign drawing' do
      it 'returns the sign drawing with the text "high_resolution" as part of the file name' do
        expect(helper.convert_to_high_resolution(drawing_1)).to include("high_resolution")
      end
    end
  end
end
