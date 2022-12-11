# frozen_string_literal: true

require 'open-uri'

module Freelex
  class SignsController < ApplicationController
    before_action :find_vocab_sheet, :set_search_query, :footer_content

    def search
      @query = SearchQuerySanitizationService.new.sanitize_for_standard_search(permitted_params)
      @page_number = permitted_params[:p].present? ? permitted_params[:p].to_i : 1
      @results_total, @signs, @freelex_errored = Sign.paginate(@query, @page_number)
      @pagination = SignPaginationService.new(current_page_number: @page_number,
                                              total_num_results: @results_total,
                                              route_params: permitted_params)
    end

    def show
      @sign = Sign.find(permitted_params[:id])

      if @sign.blank?
        render_404
        return
      end

      @title = @sign.gloss_main
    end

    def autocomplete
      search_term_param = permitted_params[:term]

      if search_term_param.blank?
        head(:ok)
        return
      end

      render json: AutocompleteSearchService.new(search_term: search_term_param).find_suggestions
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
