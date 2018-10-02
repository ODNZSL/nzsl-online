# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SitemapsController, type: :controller do
  
  let(:builder) do
    sitemap = instance_double(Sitemap, xml: "<sitemap></sitemap>")
    dbl = instance_double(SitemapBuilder, first_or_generate: sitemap)
  end

  describe "#index" do
    before do
      allow(controller).to receive(:sitemap_builder).and_return(builder)
      get :index
    end

    it "returns 200" do
      expect(response).to have_http_status(:ok)
    end

    it "renders xml as the content type" do
      expect(response.content_type).to eq("application/xml") 
    end

    it "renders xml content" do
      expect(response.body).to eq "<sitemap></sitemap>"
    end
  end
end
