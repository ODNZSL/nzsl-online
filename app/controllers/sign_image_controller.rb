class SignImageController < ApplicationController
  def show
    if File.exists?(
        ImageProcessor.local_filename(
          params[:filename],
          [params[:width], params[:height]]
        )
    )
      send_file(ImageProcessor.local_filename(
        params[:filename],
        [params[:width], params[:height]]), :type => "image/png")
    else
      begin
        send_file ImageProcessor.retrieve_and_resize(
          params[:filename],
          [params[:width], params[:height]]), :type => "image/png"
      rescue
        render :nothing => true, :status => 404
      end
    end
      
  end
end
