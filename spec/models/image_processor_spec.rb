# frozen_string_literal: true

require 'rails_helper'
require 'fastimage'

RSpec.describe 'ImageProcessor' do
  subject { ImageProcessor.new(filename: filename, width: width, height: height) }

  let(:filename) { '1935/picture-W99-69.png' }
  let(:height)   { 100 }
  let(:width) { 100 }


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
