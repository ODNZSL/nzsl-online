# frozen_string_literal: true

## a sign in New Zealand Sign Language
class Sign
  require 'open-uri'
  require 'nokogiri'

  ELEMENT_NAME = 'entry'
  RESULTS_PER_PAGE = 25

  # Sign attributes
  attr_accessor :id, :video, :video_slow, :drawing, :handshape, :location_name,
                :gloss_main, :gloss_secondary, :gloss_minor, :gloss_maori,
                :word_classes, :inflection, :contains_numbers,
                :is_fingerspelling, :is_directional, :is_locatable,
                :one_or_two_handed, :age_groups, :gender_groups, :hint,
                :usage_notes, :related_to, :usage, :examples,
                :inflection_temporal, :inflection_manner_and_degree, :inflection_plural

  def borrowed_from
    related_to unless related_to == 'nzsl'
  end

  def location
    SignMenu.locations.flatten.find { |l| l.split('.')[2].downcase[0, 4] == location_name[0, 4] }
  end

  # class #

  def self.first(params)
    _count, entries = search(params)
    return nil if entries.empty?
    SignParser.new(entries.first).build_sign
  end

  def self.all(params)
    all_with_count(params)[1]
  end

  def self.all_with_count(params)
    signs = []
    count, entries = search(params)
    entries.each do |entry|
      signs << SignParser.new(entry).build_sign
    end
    [count, signs]
  end

  def self.find(all_or_first = :first, params)
    send(all_or_first, params) if all_or_first == :all || all_or_first == :first
  end

  def self.random
    first random: 1
  end

  def self.paginate(search_query, page_number)
    start_index = RESULTS_PER_PAGE * (page_number - 1) + 1
    start_index = 1 if start_index < 1
    all_with_count search_query.merge(start: start_index, num: RESULTS_PER_PAGE)
  end

  def self.current_page(per_page, last_result_index, all_result_length)
    ((last_result_index / all_result_length.to_f) * (all_result_length / per_page.to_f)).round
  end

  def self.search(params)
    xml_document = nil
    url = url_for_search(params)
    time = Benchmark.measure do
      xml_document = Nokogiri::XML(open(url))
    end
    entries = xml_document.css(ELEMENT_NAME)
    count = xml_document.css('totalhits').inner_text.to_i
    record_request_time(url, time.real, count)
    [count, entries]
  end

  def self.record_request_time(url, time, count)
    return unless Rails.application.secrets.track_search_requests?
    Request.create! url: url, elapsed_time: time, count: count, query_type: 'Sign.search'
  end

  def self.url_for_search(query)
    # The handling of arrays in query strings is different
    # in the API than in rails
    return SIGN_URL unless query.is_a?(Hash)
    query_string = []
    query.each do |k, v|
      if v.is_a?(Array)
        v.each { |ea| query_string << "#{k}=#{CGI.escape(ea.to_s)}" if ea.present? }
      elsif v.present?
        query_string << "#{k}=#{CGI.escape(v.to_s)}"
      end
    end
    "#{SIGN_URL}?#{query_string.join('&')}"
  end
end
