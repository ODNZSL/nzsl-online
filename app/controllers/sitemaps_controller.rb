class SitemapsController < ApplicationController
  layout :false
  before_action :init_sitemap

  def index
    render xml: SitemapBuilder.first_or_generate.xml
  end

  private

  def init_sitemap
    headers['Content-Type'] = 'application/xml'
  end

end