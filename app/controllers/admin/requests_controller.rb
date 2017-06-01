class Admin::RequestsController < ApplicationController
  layout 'admin'
  def index
    @requests = Request.all.order(created_at: :desc).paginate(page: params[:page])
  end
end
