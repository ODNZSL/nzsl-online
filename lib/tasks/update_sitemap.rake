# frozen_string_literal: true

namespace :sitemap do
  desc 'Pulls in an the most recent xml dump from freelex and updates the first Sitemap objects xml attribute.'
  task update: :environment do
    sitemap_builder = SitemapBuilder.new
    sitemap_builder.first_or_generate_basic
    sitemap_builder.update_sitemap
  end
end
