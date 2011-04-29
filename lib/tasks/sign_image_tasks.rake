namespace :sign_images do
  
  dimensions_regex = Regexp.new(/(\d{1,4})x(\d{1,4})/)
  
  desc "Traverse the directory of sign images, and update if necessary"
  task :refresh_cache => :environment do
    Dir["#{SIGN_IMAGE_PATH}/**/*.gif"].each do |file|
      dimensions = dimensions_from_filename(file)
      api_filename = filename_to_api_format(file)
      open(ImageProcessor.remote_filename(api_filename)) do |f|
        if File.new(SIGN_IMAGE_PATH + file).mtime != f.last_modified
          ImageProcessor.retrieve_and_resize(api_filename, dimensions)
        end
      end
    end    
  end
  
  def dimensions_from_filename(filename = "")
    dimensions_regex.match(filename)
    return [$1, $2]
  end
  
  def filename_to_api_format(filename = "")
    filename.gsub(SIGN_IMAGE_PATH, "").gsub(dimensions_regex, "").gsub(/\A\-/, "")
  end
end
