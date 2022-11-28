# frozen_string_literal: true

module Signbank
  class SignsController < ApplicationController
    before_action :find_vocab_sheet, :set_search_query, :footer_content

    def show
      @sign = Sign.find(params[:id])
      @title = @sign.gloss_main
    end

    private

    ##
    # Continue to render templates from app/views/signs
    def default_render
      render "signs/#{action_name}"
    end

    def permitted_params
      params.permit(%i[s hs l lg usage tag term p id])
    end
  end
end
