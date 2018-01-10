# frozen_string_literal: true

module Admin
  class RequestsController < ApplicationController
    before_action :authenticate_user!
    layout 'admin'
    def index
      @requests = Request.all.order(created_at: :desc).paginate(page: params[:page])
    end
  end
end
