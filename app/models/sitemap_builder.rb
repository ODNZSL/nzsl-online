class SitemapBuilder

  def self.first_or_generate 
    return Sitemap.create(xml: generate_xml) unless Sitemap.any?
    return Sitemap.first if sitemap_updated_less_than_a_day_ago?
    Sitemap.first.update(xml: generate_xml)
  end

  def self.generate_xml
    page_slugs = Page.pluck(:slug)
    sign_ids = fetch_data_dump.map(&:id)
    base_url = "#{ENV['APP_PROTOCOL']}://#{ENV['APP_DOMAIN_NAME']}/"

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
        page_slugs.each { |slug| xml.url { xml.loc base_url + slug } }
        sign_ids.each { |id| xml.url { xml.loc "#{base_url}signs/#{id}" } }
      end
    end
    builder.to_xml
  end

  private
  
  def self.fetch_data_dump
    Sign.all(xmldump: 1)
  end

  def self.sitemap_updated_less_than_a_day_ago?
    ((Time.zone.now - Sitemap.first.updated_at) / 1.day) < 1
  end

end