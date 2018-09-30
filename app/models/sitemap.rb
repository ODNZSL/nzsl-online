class Sitemap < ApplicationRecord
  attr_accessor :xmldump

  def self.xml_data 
    s = if Sitemap.first.nil?
          Sitemap.create(xmldump: Sitemap.fetch_data_dump)
        elsif sitemap_updated_less_than_a_day_ago?
          Sitemap.first
        else
          Sitemap.first.update(xmldump: Sitemap.fetch_data_dump)
        end
    return s.xmldump
  end

  def self.fetch_data_dump
    Sign.all(xmldump: 1)
  end

  private

  def self.sitemap_updated_less_than_a_day_ago?
    ((Time.now - Sitemap.first.updated_at) / 1.day) < 1
  end
end