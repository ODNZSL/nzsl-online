# frozen_string_literal: true

require 'open-uri'

class SignsController < ApplicationController
  before_action :find_vocab_sheet, :set_search_query, :footer_content

  def search
    return redirect_to root_path, alert: t('freelex.unavailable') unless freelex_enabled?

    search_query = SearchQuerySanitizationService.new.sanitize_for_standard_search(permitted_params)
    @page_number = permitted_params[:p].present? ? permitted_params[:p].to_i : 1
    @results_total, @signs = Sign.paginate(search_query, @page_number)
    @query = search_query
    @pagination_html = SignPaginationService.new(current_page_number: @page_number,
                                                 total_num_results: @results_total,
                                                 search_query: @query).pagination_links_html
  end

  def show
    @sign = find_sign

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

  def find_sign
    id = permitted_params[:id]
    freelex_enabled? ? Sign.first(id: id) : OfflineSign.find_by_id!(id) # rubocop:disable Rails/DynamicFindBy
  end

  def permitted_params
    params.permit(%i[s hs l lg usage tag term p id])
  end
end
