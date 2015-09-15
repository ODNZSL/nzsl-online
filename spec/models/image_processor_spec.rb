require 'spec_helper'
require 'fastimage'

describe 'ImageProcessor' do
  let(:filename) do
    '1935/picture-W99-69.png'
  end

  it 'retrieves an image' do
    width = 100
    height = 100
    file = ImageProcessor.retrieve_and_resize(filename, [width, height])
    expect(File.exist?(file)).to be(true)
  end

  it 'resizes an image' do
    width = 100
    height = 100
    retrieved_file = ImageProcessor.retrieve_and_resize(filename,
                                                        [width, height])
    expect(File.exist?(retrieved_file)).to be(true)

    actual_width, actual_height = FastImage.size(retrieved_file)

    expect(actual_width).to be <= width
    expect(actual_height).to be <= height
  end

  it 'works out the remote path to image' do
    expect(ImageProcessor.remote_filename(filename)).to start_with('http://')
  end

  it 'works out the local path to image' do
    expect(ImageProcessor.local_filename(filename)).to end_with(
      '/system/images/signs/1935/180x320-1935-picture-W99-69.png')
  end

  it 'create_or_return_path' do
    expect(ImageProcessor.create_or_return_path(filename)).to end_with(
      'public/system/images/signs/1935')
  end
end
