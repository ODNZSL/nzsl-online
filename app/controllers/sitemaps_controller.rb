class SitemapsController < ApplicationController
  layout :false
  before_action :init_sitemap

  def index
    @page_slugs = Page.pluck(:slug)
    @sign_ids = Sign.all(xmldump: 1).map(&:id)

    respond_to do |format|
      format.xml
    end
  end

  private

  def init_sitemap
    headers['Content-Type'] = 'application/xml'
  end

end