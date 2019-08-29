# frozen_string_literal: true

class SignImageController < ApplicationController
  ##
  # We use Chrome (via Puppeteer) to render PDF versions of the Vocab sheets by
  #
  # 1. Write a print view of the the Vocab sheet HTML to disk
  # 2. Convert that HTML file to PDF
  #
  # We can (and do) supply HTTP basic auth credentials for step 1. above but
  # Puppeteer doesn't provide a way for us to supply HTTP basic auth
  # credentials for step 2. Step 2. involves loading some sign images from the
  # app (i.e. hitting SignImageController#show) so it will not render the Vocab
  # sheet correctly if HTTP basic auth is required for
  # SignImageController#show.
  #
  # The goal of HTTP basic authentication on staging is to keep new features
  # hidden until they are ready and ensure that search engines do not index
  # staging. Making sign images accessible without HTTP basic auth doesn't stop
  # us from meeting those goals so we diable HTTP basic auth for
  # SignImageController#show
  #
  skip_before_action :staging_http_auth, only: [:show]

  def show
    @local_filename = ImageProcessor.new(filename: filename_param,
                                         height: height_param,
                                         width: width_param).return_file_from_cache
    send_file(@local_filename,
              type: 'image/png',
              disposition: 'attachment',
              filename: filename_param)
  rescue OpenURI::HTTPError
    head(:not_found)
  rescue RuntimeError
    head(:forbidden)
  end

  private

  def filename_param
    return sign_image_params[:filename] if %r{^[\d]+\/[a-zA-z\-0-9]+\.png$}.match?(sign_image_params[:filename])

    raise 'Invalid filename'
  end

  def width_param
    sign_image_params[:width].to_i
  rescue StandardError
    400
  end

  def height_param
    sign_image_params[:height].to_i
  rescue StandardError
    400
  end

  def sign_image_params
    params.permit(:filename, :height, :width)
  end
end
