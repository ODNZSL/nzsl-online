class SignImageController < ApplicationController
  def show
    image_filename = ImageProcessor.local_filename(params[:filename], [params[:width].to_i, params[:height].to_i])

    return send_file(image_filename, type: 'image/png', disposition: 'attachment', filename: params[:filename]) if File.exist?(image_filename)

    begin
      send_file(ImageProcessor.retrieve_and_resize(
                  params[:filename],
                  [params[:width], params[:height]]), type: 'image/png', disposition: 'attachment', filename: params[:filename])
    rescue Exception => e
      logger.error e
      render nothing: true, status: 404
    end
  end
end
