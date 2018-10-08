# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SitemapBuilder', type: :model do
  let(:sitemap_builder) { SitemapBuilder.new }

  before do
    signs = 3.times.map do |int|
              sign = Sign.new
              sign.id = int + 1
              sign
            end
    allow(sitemap_builder).to receive(:fetch_all_signs).and_return(signs)
  end

  describe '#first_or_generate_basic' do
    let!(:sitemap) { FactoryBot.create(:sitemap) }

    context 'when a Sitemap record exists' do
      it 'returns that record' do
        expect(sitemap_builder.first_or_generate_basic).to eq(sitemap)
      end
    end

    context 'when a Sitemap record does not exist' do
      before do
        Sitemap.first.delete
      end

      it 'generates one' do
        expect(Sitemap.first).to be_nil
        expect(sitemap_builder.first_or_generate_basic).not_to eq(sitemap)
        expect(Sitemap.first).not_to be_nil
      end
    end
  end

  describe '#update_sitemap' do
    let!(:sitemap) { FactoryBot.create(:sitemap) }

    before do
      allow(sitemap_builder).to receive(:generate_xml).and_return('<different-xml></different-xml>')
    end
    it 'updates the first existing Sitemap record in the database' do
      expect(Sitemap.first.xml).to eq('<sitemap></sitemap>')
      expect(sitemap_builder.update_sitemap).to eq(true)
      expect(Sitemap.first.xml).to eq('<different-xml></different-xml>')
    end
  end

  describe '#generate_xml' do
    context 'when an array of slugs are provided' do
      let(:slugs) { ['contact', 'signs/22', 'dogs'] }
      let(:base_url) { Rails.application.config.base_url }

      it 'returns the expected set of xml data featuring those slugs' do
        expect(sitemap_builder.generate_xml(slugs)).to include("#{base_url}signs/22")
      end
    end
  end

  describe '#page_slugs' do
    before do
      FactoryBot.create(:page, slug: 'trees')
      FactoryBot.create_list(:page, 2)
    end
    it 'returns an array of all slugs for the page model' do
      response = sitemap_builder.send(:page_slugs)
      expect(response.length).to eq(3)
      expect(response.first).to eq('trees')
    end
  end

  describe '#sign_slugs' do
    it 'returns an array of sign ids formatted into sign page slugs' do
      response = sitemap_builder.send(:sign_slugs)
      expect(response).to eq(['signs/1', 'signs/2', 'signs/3'])
    end
  end
end
