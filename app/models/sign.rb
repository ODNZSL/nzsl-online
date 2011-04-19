class Sign


  require 'open-uri'
  require 'nokogiri'

  cattr_accessor :url
  cattr_accessor :element_name
  cattr_accessor :asset_url
  cattr_accessor :results_per_page



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
  attr_writer :drawing

  attr_accessor :recipe
  attr_accessor :hint
  attr_accessor :usage_notes

  attr_accessor :contains_numbers
  attr_accessor :is_fingerspelling
  attr_accessor :is_directional
  attr_accessor :is_locatable
  attr_accessor :two_handed


  Sign.url = "http://nzsl.vuw.ac.nz/dnzsl/freelex/publicsearch"
  Sign.element_name = "entry"
  Sign.asset_url = "http://nzsl.vuw.ac.nz/dnzsl/freelex/assets/"
  Sign.results_per_page = 2

  def self.find(all_or_first = :all, params)
    #xml_document = Nokogiri::XML(open(url_for_search(params)))
    xml_document = Nokogiri::XML(open(url_for_search(params)))
    ::Rails.logger.info "SIGN SEARCH: Requesting: #{url_for_search(params)}."
    entries = xml_document.css(Sign.element_name)
    if all_or_first == :first
      return nil if entries.empty?
      return  populate_object_from(entries.first)
      ::Rails.logger.info "SIGN SEARCH: 1 Result returned."
    else
      signs = []
      entries.each do |entry|
        signs << populate_object_from(entry)
      end
      count = xml_document.css("totalhits").inner_text
      ::Rails.logger.info "SIGN SEARCH: #{count} Results returned."
      return [count, signs]
    end
  end

  def self.random
    return self.first({:random => 1})
  end

  def self.paginate(search_query, page_number = 1)
    start_index = Sign.results_per_page * (page_number - 1) + 1
    start_index = 1 if start_index < 1
    self.all(search_query.merge!(:start => start_index, :num => Sign.results_per_page))
  end

  #Helper methods
  def self.first(params)
    self.find(:first, params)
  end

  def self.all(params)
    return self.find(:all, params)
  end

  def drawing
    Sign.asset_url + @drawing
  end

  def self.current_page(per_page, last_result_index, all_result_length)
    ((last_result_index / all_result_length.to_f) * (all_result_length / per_page.to_f)).round
  end

private

  def self.url_for_search(query)
    return Sign.url unless query.is_a?(Hash)
    return Sign.url + "?" + query.to_query
  end

  def self.populate_object_from(data)
    sign = Sign.new

    sign.id = data.value_for_tag("headwordid")
    sign.gloss_main = data.value_for_tag("glossmain")
    sign.gloss_secondary = data.value_for_tag("glosssecondary")
    sign.gloss_minor = data.value_for_tag("gloss_minor")
    sign.gloss_maori = data.value_for_tag("gloss_maori")

    sign.word_classes = data.value_for_tag("SECONDARYWORDCLASS")
    sign.inflection = data.value_for_tag("INFLECTION")
    sign.age_groups = data.value_for_tag("VARIATIONAGE")
    sign.gender_groups = data.value_for_tag("VARIATIONGENDER")

    sign.video = data.value_for_tag("ASSET glossmain")
    sign.drawing = data.value_for_tag("ASSET picture")

    sign.recipe = data.value_for_tag("recipe")
    sign.recipe = data.value_for_tag("hint")
    sign.usage_notes = data.value_for_tag("essay")

    sign.contains_numbers = data.value_for_tag("number_incorp").to_bool
    sign.is_fingerspelling = data.value_for_tag("fingerspelling").to_bool
    sign.is_directional = data.value_for_tag("directional").to_bool
    sign.is_locatable = data.value_for_tag("locatable").to_bool
    sign.two_handed = data.value_for_tag("one_or_two_handed").to_bool

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

