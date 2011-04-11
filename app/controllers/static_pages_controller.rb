class StaticPagesController < ApplicationController
  def show
    begin
      render :template => "static_pages/#{params[:slug].downcase}"
    #rescue
    #  render :status => 404, :nothing => true
    end
  end

end

