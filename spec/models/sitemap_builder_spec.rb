# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SitemapBuilder', type: :model do
  
  let(:builder) do
    instance_double(SitemapBuilder, fetch_data_dump: "[{sign:{id:1}, {sign:{id:2}}]")
  end

  describe "#first_or_generate" do
    let!(:sitemap) { FactoryBot.create(:sitemap) }

    context "when a Sitemap record exists" do
      it "returns that record" do
        expect(builder.first_or_generate).to eq(sitemap)
      end
    end

    context "when a Sitemap record does not exist" do
      before do
        Sitemap.first.delete
      end

      it "generates one" do
        expect(builder.first_or_generate).not_to eq(sitemap)
        expect(Sitemap.first).not_to be_nil
      end
    end
  end

  describe "#update_sitemap" do
    let!(:sitemap) { FactoryBot.create(:sitemap) }
    
    it "updates the first existing Sitemap record in the database" do
      expect(builder.update_sitemap.id).to_eq eq(sitemap.id)
    end
  end

  describe "#generate_xml" do
    context "when an array of slugs are provided" do
      let(:slugs) {["contact", "signs/22", "dogs"]}
      let(:base_url) {Rails.application.config.base_url}
      it "returns the expected set of xml data featuring those slugs" do
        expect(builder.generate_xml(slugs)).to include("#{base_url}signs/22")
      end
    end
  end

  describe "#fetch_data_dump" do
    it "returns a set of xml data in the expected format" do
    end
  end

  describe "#page_slugs" do
    it "returns an array of all slugs for the page model" do
    end
  end

  describe "#sign_slugs" do
    it "returns an array of sign ids formatted into sign page slugs" do
    end
  end

end
