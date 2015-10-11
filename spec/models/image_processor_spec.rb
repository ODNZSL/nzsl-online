require 'rails_helper'
require 'fastimage'

describe 'ImageProcessor' do
  let(:filename) do
    '1935/picture-W99-69.png'
  end

  it 'retrieves an image' do
    width = 100
    height = 100
    file = ImageProcessor.new(filename: filename, width: width, height: height).resize_and_cache
    expect(File.exist?(file)).to be(true)
  end

  it 'resizes an image' do
    width = 100
    height = 100
    retrieved_file = ImageProcessor.new(filename: filename, width: width, height: height).resize_and_cache
    expect(File.exist?(retrieved_file)).to be(true)

    actual_width, actual_height = FastImage.size(retrieved_file)

    expect(actual_width).to be <= width
    expect(actual_height).to be <= height
  end
end
