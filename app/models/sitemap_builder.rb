class SitemapBuilder
  def first_or_generate_basic
    Sitemap.first || Sitemap.create(xml: generate_xml(page_slugs))
  end

  def update_sitemap
    Sitemap.first.update(xml: generate_xml(page_slugs + sign_slugs))
  end

  def generate_xml(slugs)
    base_url = Rails.application.config.base_url

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
        slugs.each { |slug| xml.url { xml.loc base_url + slug } }
      end
    end

    builder.to_xml
  end

  private

  def fetch_all_signs
    Sign.all(xmldump: 1)
  end

  def page_slugs
    Page.pluck(:slug)
  end

  def sign_slugs
    fetch_all_signs.map { |sign| "signs/#{sign.id}" }
  end
end
