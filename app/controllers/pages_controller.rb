# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :set_search_query, :footer_content

  def show
    @page = Page.find_by(slug: slug_param)
    return render_404 unless @page

    @title = @page.title
    @feedback = Feedback.new if @page.template == 'feedback'
    @sign = Signbank::SignOfTheDay.find

    render template: "pages/#{@page.template}"
  end

  def random_sign
    @page = Page.find_by(slug: '/')
    @title = @page.title
    @sign = Signbank::Sign.random

    render template: "pages/#{@page.template}"
  end

  private

  def slug_param
    params[:slug].presence || '/'
  end
end
