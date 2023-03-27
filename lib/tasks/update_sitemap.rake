# frozen_string_literal: true

namespace :sitemap do
  desc 'Pulls in Sign database data and updates the first Sitemap objects xml attribute.'
  task update: :environment do
    sitemap_builder = SitemapBuilder.new
    sitemap_builder.first_or_generate_basic
    sitemap_builder.update_sitemap
  end
end
