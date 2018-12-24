# frozen_string_literal: true

require 'fileutils'

namespace :sign_images do
  DIMENSIONS_REGEXP = Regexp.new(/(\d{1,4})x(\d{1,4})/)

  desc 'Clears the cache by deleting all files inside the sign image directory'
  task clear_cache: :environment do
    puts "Removing files in #{SIGN_IMAGE_PATH}....\n"
    Dir.foreach(SIGN_IMAGE_PATH) do |file|
      next if file == '.' || file == '..'

      file = File.join(SIGN_IMAGE_PATH, file)
      puts "rm #{file}\n"
      if File.directory?(File.join(SIGN_IMAGE_PATH, file))
        FileUtils.rm_rf(File.join(SIGN_IMAGE_PATH, file))
      else
        FileUtils.rm(File.join(SIGN_IMAGE_PATH, file))
      end
    end
    puts "...Done.\n"
  end

  desc 'Traverse the directory of sign images, and update if necessary'
  task refresh_cache: :environment do
    Dir["#{SIGN_IMAGE_PATH}/**/*.gif"].each do |file|
      dimensions = dimensions_from_filename(file)
      api_filename = filename_to_api_format(file)
      open(ImageProcessor.remote_filename(api_filename)) do |f|
        ImageProcessor.retrieve_and_resize(api_filename, dimensions) if File.new(SIGN_IMAGE_PATH + file).mtime != f.last_modified
      end
    end
  end

  def dimensions_from_filename(filename = '')
    DIMENSIONS_REGEXP.match(filename)
    [Regexp.last_match(1), Regexp.last_match(2)]
  end

  def filename_to_api_format(filename = '')
    filename.gsub(SIGN_IMAGE_PATH, '').gsub(DIMENSIONS_REGEXP, '').gsub(/\A\-/, '')
  end
end
