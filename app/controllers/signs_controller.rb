class SignsController < ApplicationController
  require 'open-uri'

  before_action :find_vocab_sheet, :set_search_query, :footer_content

  def search
    search_query = process_search_query(params)
    @page_number = params[:p].present? ? params[:p].to_i : 1
    @results_total, @signs = Sign.paginate(search_query, @page_number)
    @query = search_query
  end

  def show
    @sign = Sign.first(id: params[:id])
    render_404 if @sign.blank?
    @title = @sign.gloss_main
  end

  def autocomplete
    if params[:term].present?
      render json: open("#{AUTOCOMPLETE_URL}?q=#{CGI.escape(params[:term])}&limit=10", &:read).split("\n")
    else
      render :nothing
    end
  end

  private

  def process_search_query(params)
    search_keys = %w(s hs l lg usage tag)
    query = params.select { |k| search_keys.include? k }
    query.each do |k, v|
      if k == 's'
        query[k] = [v]
      else
        query[k] = v.split(' ')
      end
    end
    HashWithIndifferentAccess.new(query)
  end
end
