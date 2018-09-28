# frozen_string_literal: true

## Retrieves images from Freelex, resizes and saves locally
class ImageProcessor
  require 'mini_magick'
  require 'open-uri'

  def initialize(filename:, height:, width:)
    @filename = filename
    @height = height
    @width = width

    @remote_filename = ASSET_URL + filename
    @local_filename = calculate_local_filename
  end

  def return_file_from_cache
    return @local_filename if local_file_exists && local_file_age_in_days < 1
    write_file_locally
    @local_filename
  end

  private

  def write_file_locally
    image = MiniMagick::Image.open(@remote_filename)
    image.format 'png'
    image.write @local_filename
  end

  def local_file_exists
    File.exist?(@local_filename)
  end

  def local_file_age_in_days
    (Time.zone.now - File.stat(@local_filename).mtime).to_i / 86_400.0
  end

  def create_or_return_path(filename)
    # ensure the sign path exists
    Dir.mkdir(SIGN_IMAGE_PATH) unless Dir.exist?(SIGN_IMAGE_PATH)

    # It is expected that filename is in the 1212/sdsd.png format
    file_parts = filename.split File::SEPARATOR

    return SIGN_IMAGE_PATH if file_parts.empty?

    sign_dir = File.join(SIGN_IMAGE_PATH, file_parts[0])

    Dir.mkdir sign_dir unless Dir.exist?(sign_dir)
    sign_dir
  end

  def dimensions
    [@width, @height]
  end

  def calculate_local_filename
    File.join(create_or_return_path(@filename),
              dimensions.join('x') + "-#{@filename.gsub(%r{[\/\\]}, '-')}")
  end
end
