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
      [params[:width], params[:height]]), :type => "image/png", :disposition => 'attachment', :filename => params[:filename])
    else
      begin
        send_file(ImageProcessor.retrieve_and_resize(
          params[:filename],
          [params[:width], params[:height]]), :type => "image/png", :disposition => 'attachment', :filename => params[:filename])
      rescue Exception => e
        logger.error e
        render :nothing => true, :status => 404
      end
    end
  end
end
