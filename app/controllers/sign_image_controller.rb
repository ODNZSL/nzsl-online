class SignImageController < ApplicationController
  def show
    local_filename = ImageProcessor.new(filename: params['filename'],
                                        height: params['height'],
                                        width: params['width']).resize_and_cache

    send_file(local_filename,
              type: 'image/png',
              disposition: 'attachment',
              filename: params[:filename])
  end
end
