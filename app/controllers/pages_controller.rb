# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_search_query, :footer_content

  def show
    @page = Page.find_by(slug: slug_param)
    return render_404 unless @page

    @title = @page.title
    @feedback = Feedback.new if @page.template == 'feedback'
    @sign = Sign.sign_of_the_day if @page.template == 'home' && freelex_enabled?

    flash[:error] = t("freelex.unavailable") unless freelex_enabled?

    render template: "pages/#{@page.template}"
  end

  def random_sign
    @page = Page.find_by(slug: '/')
    @title = @page.title
    @sign = Sign.random

    render template: "pages/#{@page.template}"
  end

  private

  def slug_param
    params[:slug].presence || '/'
  end
end
