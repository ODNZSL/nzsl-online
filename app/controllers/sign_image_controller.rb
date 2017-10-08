class SignImageController < ApplicationController
  def show
    @local_filename = ImageProcessor.new(filename: filename_param,
                                         height: height_param,
                                         width: width_param).resize_and_cache
    send_file(@local_filename,
              type: 'image/png',
              disposition: 'attachment',
              filename: filename_param)
  rescue OpenURI::HTTPError
    return head(:not_found)
  rescue RuntimeError
    return head(:forbidden)
  end

  private

  def filename_param
    return sign_image_params[:filename] if %r{^[\d]+\/[a-zA-z\-0-9]+\.png$} =~ sign_image_params[:filename]
    raise 'Invalid filename'
  end

  def width_param
    sign_image_params[:width].to_i
  rescue
    100
  end

  def height_param
    sign_image_params[:height].to_i
  rescue
    100
  end

  def sign_image_params
    params.permit(:filename, :height, :width)
  end
end
