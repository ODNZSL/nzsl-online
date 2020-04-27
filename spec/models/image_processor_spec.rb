# frozen_string_literal: true

require 'rails_helper'
require 'fastimage'

RSpec.describe 'ImageProcessor' do
  subject { ImageProcessor.new(filename: filename, width: width, height: height) }

  let(:filename) { '5519/victoria_university-5519-default.png' }
  let(:height) { 100 }
  let(:width) { 100 }

  describe '#resize_and_cache' do
    subject { super().return_file_from_cache }

    it 'retrieves an image' do
      expect(File.exist?(subject)).to be(true)
    end
  end
end
