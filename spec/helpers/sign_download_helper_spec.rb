# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignDownloadHelper, type: :helper do
  describe '#download-link' do
    context 'when provided with a "high_resolution" value to download' do
      it 'returns the sign drawing with the text "high_resolution" as part of the file name' do
        # classes = helper.send(:download-link, :location, true)
        # expect(classes.split(' ')).to include('image', 'rounded', 'main_image')
      end
    end
  end
end
