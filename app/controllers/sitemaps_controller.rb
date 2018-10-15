# frozen_string_literal: true

class SitemapsController < ApplicationController
  layout false
  before_action :init_sitemap

  def index
    render xml: sitemap_builder.first_or_generate_basic.xml
  end

  private

  def init_sitemap
    headers['Content-Type'] = 'application/xml'
  end

  def sitemap_builder
    SitemapBuilder.new
  end
end
