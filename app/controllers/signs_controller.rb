class SignsController < ApplicationController

  def search
    search_query = process_search_query(params)
    page_number = params[:p].present? ? params[:p].to_i : 1
    @results_total, @signs = Sign.paginate(search_query, page_number)
    session[:search] = {:count => @results_total, :query => search_query, :p => page_number}
    @query = session[:search][:query]
  end

  def show
    @sign = Sign.first({:id => params[:id]})
  end
  
private
  def process_search_query params
    search_keys = %w(s hs l lg usage tag)
    query = params.select{|k| search_keys.include? k}
    query.each { |k,v| query[k] = v.is_a?(String) ? v.split(' ') : v }
    p query
    return query
  end
end

