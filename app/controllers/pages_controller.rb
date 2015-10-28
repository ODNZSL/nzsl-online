class PagesController < ApplicationController
  before_action :set_search_query, :footer_content

  def show
    @page = Page.find_by_slug(params[:slug])
    return render_404 unless @page

    @title = @page.title
    @feedback = Feedback.new if @page.template == 'feedback'
    render template: "pages/#{@page.template}"
  end
end
