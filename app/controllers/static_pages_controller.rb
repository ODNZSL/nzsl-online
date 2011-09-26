class StaticPagesController < ApplicationController
  
  before_filter :find_vocab_sheet, :set_search_query, :get_footer_content
  
  def show
    begin
      render :template => "static_pages/#{template_for_slug(params[:slug])}"
    rescue ActionView::MissingTemplate
      render :status => 404, :template => 'static_pages/404'
    end
  end
  
private

  def template_for_slug slug
    @slug = slug || ''
    @slug = @slug.downcase
    return 'index' if @slug.empty?
    return @slug
  end
end

