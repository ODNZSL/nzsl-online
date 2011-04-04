class Sign

  require 'open-uri'
  require 'nokogiri'

  cattr_accessor :url
  cattr_accessor :element_name

  #Sign attributes
  attr_accessor :id
  attr_accessor :gloss_main
  attr_accessor :gloss_secondary
  attr_accessor :gloss_minor
  attr_accessor :gloss_maori

  attr_accessor :word_classes
  attr_accessor :inflection
  attr_accessor :age_groups
  attr_accessor :gender_groups

  attr_accessor :video
  attr_accessor :drawing

  attr_accessor :recipe
  attr_accessor :usage_notes

  attr_accessor :contains_numbers
  attr_accessor :is_fingerspelling
  attr_accessor :is_directional
  attr_accessor :is_locatable


  Sign.url = "http://nzsl.vuw.ac.nz/dnzsl/freelex/publicsearch"
  Sign.element_name = "entry"

  def self.find(all_or_first = :all, params)
    #xml_document = Nokogiri::XML(open(url_for_search(params)))
    xml_document = Nokogiri::XML(open("/home/josh/Projects/nzsl-online/publicsearch_cat.xml"))
    entries = xml_document.css(Sign.element_name)
    if all_or_first == :first
      return nil if entries.empty?
      return populate_object_from(entries.first)
    else
      signs = []
      entries.each do |entry|
        signs << populate_object_from(entry)
      end
      return signs
    end
  end

  def self.random
    return self.first({:random => 1})
  end

  #Helper methods
  def self.first(params)
    return self.find(:first, params)
  end

  def self.all(params)
    return self.find(:all, params)
  end


  private

  def self.url_for_search(query)
    return Sign.url unless query.is_a?(Hash)
    return Sign.url + "?" + query.to_query
  end

  def self.populate_object_from(data)
    sign = Sign.new

    sign.id = data.value_for_tag("headword_id")
    sign.gloss_main = data.value_for_tag("glossmain")
    sign.gloss_secondary = data.value_for_tag("glosssecondary")
    sign.gloss_minor = data.value_for_tag("gloss_minor")
    sign.gloss_maori = data.value_for_tag("gloss_maori")

    sign.word_classes = data.value_for_tag("SECONDARYWORDCLASS")
    sign.inflection = data.value_for_tag("inflection")
    sign.age_groups = data.value_for_tag("variationage")
    sign.gender_groups = data.value_for_tag("variationgender")

    sign.video = data.value_for_tag("ASSET glossmain")
    sign.drawing = data.value_for_tag("ASSET picture")

    sign.recipe = data.value_for_tag("recipe")
    sign.usage_notes = data.value_for_tag("essay")

    sign.contains_numbers = data.value_for_tag("number_incorp")
    sign.is_fingerspelling = data.value_for_tag("fingerspelling")
    sign.is_directional = data.value_for_tag("directional")
    sign.is_locatable = data.value_for_tag("locatable")

    return sign
  end

  #Extend Nokogiri with helper method for fetching value
  Nokogiri::XML::Element.class_eval do
    def value_for_tag(tag_name)
      tag = self.css(tag_name).first
      tag.is_a?(Nokogiri::XML::Node) ? tag.content() : ""
    end
  end

end

