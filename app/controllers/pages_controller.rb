class PagesController < ApplicationController
  before_action :set_search_query, :get_footer_content

  def show
    if @page = Page.find_by_slug(params[:slug])
      @title = @page.title
      @feedback = Feedback.new if @page.template == 'feedback'
      render template: "pages/#{@page.template}"
    else
      render_404
    end
  end
end
