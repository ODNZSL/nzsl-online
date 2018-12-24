# frozen_string_literal: true

class SignsController < ApplicationController
  require 'open-uri'

  before_action :find_vocab_sheet, :set_search_query, :footer_content

  def search
    search_query = process_search_query
    @page_number = permitted_params[:p].present? ? permitted_params[:p].to_i : 1
    @results_total, @signs = Sign.paginate(search_query, @page_number)
    @query = search_query
  end

  def show
    @sign = Sign.first(id: permitted_params[:id])

    if @sign.blank?
      render_404
      return
    end

    @title = @sign.gloss_main
  end

  def autocomplete
    if permitted_params[:term].present?
      render json: open("#{AUTOCOMPLETE_URL}?q=#{CGI.escape(permitted_params[:term])}&limit=10", &:read).split("\n")
    else
      head :ok
    end
  end

  private

  def process_search_query
    search_keys = %w(s hs l lg usage tag)
    query = permitted_params.select { |key| search_keys.include?(key) }
    return {} if query.nil?

    query.each do |key, value|
      secondary_value = value.nil? ? '' : value.split(' ')
      query[key] = key == 's' ? [value] : secondary_value
    end
    query.to_h
  end

  def permitted_params
    params.permit(%i[s hs l lg usage tag term p id])
  end
end
