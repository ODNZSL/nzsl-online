# frozen_string_literal: true

require 'rails_helper'
require 'fastimage'

RSpec.describe 'ImageProcessor' do
  subject { ImageProcessor.new(filename: filename, width: width, height: height) }

  let(:filename) { '5519/victoria_university-5519.png' }
  let(:height)   { 50 }
  let(:width) { 40 }

  describe '#resize_and_cache' do
    subject { super().resize_and_cache }

    it 'retrieves an image' do
      expect(File.exist?(subject)).to be(true)
    end

    it 'resizes an image' do
      actual_width, actual_height = FastImage.size(subject)

      expect(actual_width).to be <= width
      expect(actual_height).to be <= height
    end
  end
end
