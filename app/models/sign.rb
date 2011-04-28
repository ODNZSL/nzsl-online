class Sign

  require 'open-uri'
  require 'nokogiri'

  ELEMENT_NAME = 'entry'
  RESULTS_PER_PAGE = 9
  VIDEO_EXAMPLES_TOTAL = 3
  #Sign attributes
  attr_accessor :id, :video, :drawing, :handshape, :location,
                :gloss_main, :gloss_secondary, :gloss_minor, :gloss_maori, 
                :word_classes, :inflection, :contains_numbers, :is_fingerspelling, :is_directional, :is_locatable, :one_or_two_handed,
                :age_groups, :gender_groups, :hint, :usage_notes, :related_to,
                :examples
  
  def initialize(data = nil)
    if data
      self.id = data.value_for_tag("headwordid")
      self.video = "#{ASSET_URL}#{data.value_for_tag("ASSET glossmain")}"
      self.drawing = "#{ASSET_URL}#{data.value_for_tag("ASSET picture")}"
      self.handshape = data.value_for_tag("handshape")
      self.location = data.value_for_tag("location")
      
      #gloss
      self.gloss_main = data.value_for_tag("glossmain")
      self.gloss_secondary = data.value_for_tag("glosssecondary")
      self.gloss_minor = data.value_for_tag("gloss_minor")
      self.gloss_maori = data.value_for_tag("gloss_maori")
      
      #grammar
      self.word_classes = data.value_for_tag("SECONDARYWORDCLASS")
      self.inflection = data.value_for_tag("INFLECTION")
      self.contains_numbers = data.value_for_tag("number_incorp").to_bool
      self.is_fingerspelling = data.value_for_tag("fingerspelling").to_bool
      self.is_directional = data.value_for_tag("directional").to_bool
      self.is_locatable = data.value_for_tag("locatable").to_bool
      self.one_or_two_handed = data.value_for_tag("one_or_two_hand").to_bool
      #notes
      self.age_groups = data.value_for_tag("VARIATIONAGE")
      self.gender_groups = data.value_for_tag("VARIATIONGENDER")
      self.hint = data.value_for_tag("hint")
      self.usage_notes = data.value_for_tag("essay")
      self.related_to = data.value_for_tag("RELATEDTO")
      self.related_to = "" if self.related_to == 'nzsl'
      #examples
      self.examples = []
      VIDEO_EXAMPLES_TOTAL.times do |i|
        self.examples << {:transcription => parse_transcription(data, "videoexample#{i}"), 
                          :translation => data.value_for_tag("videoexample#{i}translation"),
                          :video => "#{ASSET_URL}#{data.value_for_tag("ASSET finalexample#{i}")}"} if data.value_for_tag("ASSET finalexample#{i}").present?
      end
    end
    self
  end
  
  def inflection_temporal
    !!inflection.match('temporal')
  end
  
  def inflection_manner_and_degree
    !!inflection.match('manner')
  end
  
  def inflection_plural
    !!inflection.match('plural')
  end
  
  def self.first(params)
    count, entries = self.search(params)
    return nil if entries.empty?
    Sign.new(entries.first)
  end

  def self.all(params)
    signs = []
    count, entries = self.search(params)
    entries.each do |entry|
      signs << Sign.new(entry)
    end
    return [count, signs]
  end
  
  def self.find(all_or_first = :all, params)
    if all_or_first == :all || all_or_first == :first
      self.send(all_or_first, params) 
    end
  end
  
  def self.random
    return self.first({:random => 1})
  end

  def self.paginate(search_query, page_number)
    start_index = RESULTS_PER_PAGE * (page_number - 1) + 1
    start_index = 1 if start_index < 1
    self.all(search_query.merge(:start => start_index, :num => RESULTS_PER_PAGE))
  end
  
  def self.current_page(per_page, last_result_index, all_result_length)
    ((last_result_index / all_result_length.to_f) * (all_result_length / per_page.to_f)).round
  end
  
private

  def self.search(params)
    xml_document = Nokogiri::XML(open(url_for_search(params)))
    entries = xml_document.css(ELEMENT_NAME)
    count = xml_document.css("totalhits").inner_text.to_i
    return [count, entries]
  end
  
  def self.url_for_search(query)
    #todo: handle quotes, handle special characters, handle encoding.
    # The handling of arrays in query strings is different in the API than in rails
    return SIGN_URL unless query.is_a?(Hash)
    query_string = []
    query.each do |k, v|
      if v.is_a?(Array)
        v.each {|ea| query_string << "#{k}=#{CGI::escape(ea.to_s)}" if ea.present?} 
      elsif v.present?
        query_string << "#{k}=#{CGI::escape(v.to_s)}"
      end
    end
    "#{SIGN_URL}?#{query_string.join("&")}"
  end
    
  def parse_transcription(data, tag)
    transcription = []
    data.css(tag).children.each do |item|
      if item.is_a?(Nokogiri::XML::Text) 
        transcription += item.content.split(' ')
      else 
        transcription << {:id => item['id'], :gloss => item.children.first.content}
      end
    end
    transcription
  end
  
  #Extend Nokogiri with helper method for fetching value
  Nokogiri::XML::Element.class_eval do
    def value_for_tag(tag_name)
      tag = self.css(tag_name).first
      tag.is_a?(Nokogiri::XML::Node) ? tag.content() : ""
    end
  end
  
end

