## Retrieves images from Freelex, resizes and saves locally
class ImageProcessor
  require 'mini_magick'
  require 'open-uri'
  require 'fileutils'

  def self.retrieve_and_resize(filename, dimensions = [180, 320])
    puts 'Fetching ' + filename
    remote_filename = ImageProcessor.remote_filename(filename)
    begin
      image = MiniMagick::Image.open(remote_filename)
      image.shave CROP_IMAGES_BY if CROP_IMAGES
    rescue Exception => e
      puts e
      puts "perhaps image magick isn't installed, or is not on the PATH"
      raise
    end

    # Reset page size to cropped image to avoid offset issue.
    # See here: http://studio.imagemagick.org/pipermail/magick-bugs/2008-May/002933.html
    width  = image['width']
    height = image['height']
    image.set('page', "#{width}x#{height}+0+0")
    image.resize dimensions.join('x') + '>'
    image.format 'png'
    image.write ImageProcessor.local_filename(filename, dimensions)
    ImageProcessor.local_filename(filename, dimensions)
  end

  def self.remote_filename(filename = '')
    ASSET_URL + filename
  end

  def self.create_or_return_path(filename)
    # It is expected that filename is in the 1212/sdsd.png format
    file_parts = filename.split '/'
    FileUtils.mkdir_p(SIGN_IMAGE_PATH) unless File.exist?(SIGN_IMAGE_PATH)
    if file_parts.length > 1
      return File.join(SIGN_IMAGE_PATH, file_parts[0]) if Dir.exist?(File.join(SIGN_IMAGE_PATH, file_parts[0]))
      Dir.chdir(SIGN_IMAGE_PATH) && Dir.mkdir(file_parts[0])
      return File.join(SIGN_IMAGE_PATH, file_parts[0])
    else
      return SIGN_IMAGE_PATH
    end
  end

  def self.local_filename(filename = '', dimensions = [180, 320])
    File.join(ImageProcessor.create_or_return_path(filename),
              dimensions.join('x') + "-#{filename.gsub(/[\/\\]/, "-")}")
  end
end
