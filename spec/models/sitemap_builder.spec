# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SitemapBuilder', type: :model do

  describe "#first_or_generate" do
    context "when a Sitemap record exists" do
      it "returns that record" do
      end
    end

    context "when a Sitemap record does not exist" do
      it "generates one" do
      end
    end
  end

  describe "#update_sitemap" do
    it "updates the first existing Sitemap record in the database" do
    end
  end

  describe "#generate_xml" do
    context "when an array of slugs are provided" do
      it "returns the expected set of xml data featuring those slugs" do
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
