class SitemapsController < ApplicationController
  layout :false
  before_action :init_sitemap

  def index
    @page_slugs = Page.pluck(:slug)
    @sitemap_data = Sitemap.xml_data
    @sign_ids = @sitemap_data.map(&:id)

    respond_to do |format|
      format.xml
    end
  end

  private

  def init_sitemap
    headers['Content-Type'] = 'application/xml'
  end

end