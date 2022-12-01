# frozen_string_literal: true

module Signbank
  class SignsController < ApplicationController
    before_action :find_vocab_sheet, :set_search_query, :footer_content

    def search
      @query = SearchQuerySanitizationService.new.sanitize_for_standard_search(permitted_params)
      @page_number = permitted_params.fetch(:p, 1).to_i
      @signs = SignSearchService.new(@query).results.page(@page_number)
      @results_total = @signs.total_entries
      @pagination = SignPaginationService.new(current_page_number: @page_number,
                                              total_num_results: @results_total,
                                              pagination_params: @query)
    end

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
