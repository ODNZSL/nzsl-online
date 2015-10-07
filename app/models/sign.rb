## a sign in New Zealand Sign Language
class Sign
  require 'open-uri'
  require 'nokogiri'

  ELEMENT_NAME = 'entry'
  RESULTS_PER_PAGE = 9

  # Sign attributes
  attr_accessor :id, :video, :video_slow, :drawing, :handshape, :location_name,
                :gloss_main, :gloss_secondary, :gloss_minor, :gloss_maori,
                :word_classes, :inflection, :contains_numbers,
                :is_fingerspelling, :is_directional, :is_locatable,
                :one_or_two_handed, :age_groups, :gender_groups, :hint,
                :usage_notes, :related_to, :usage, :examples

  def inflection_temporal
    !!inflection.match('temporal')
  end

  def inflection_manner_and_degree
    !!inflection.match('manner')
  end

  def inflection_plural
    !!inflection.match('plural')
  end

  def borrowed_from
    related_to unless related_to == 'nzsl'
  end

  def location
    Sign.locations.flatten.find { |l| l.split('.')[2].downcase == location_name }
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

  # MENUS
  def self.handshapes
    [
      [['1.1.1', '1.1.2', '1.1.3'], ['1.2.1', '1.2.2'], ['1.3.1', '1.3.2'], ['1.4.1']],
      [['2.1.1', '2.1.2'], ['2.2.1', '2.2.2'], ['2.3.1', '2.3.2', '2.3.3'], ['8.1.1', '8.1.2', '8.1.3']],
      [['3.1.1'], ['3.2.1'], ['3.3.1'], ['3.4.1', '3.4.2'], ['3.5.1', '3.5.2']],
      [['4.1.1', '4.1.2'], ['4.2.1', '4.2.2'], ['4.3.1', '4.3.2']],
      [['5.1.1', '5.1.2'], ['5.2.1'], ['5.3.1', '5.3.2'], ['5.4.1']],
      [['6.1.1', '6.1.2', '6.1.3', '6.1.4'], ['6.2.1', '6.2.2', '6.2.3', '6.2.4'], ['6.3.1', '6.3.2'],
       ['6.4.1', '6.4.2'], ['6.5.1', '6.5.2'], ['6.6.1', '6.6.2']],
      [['7.1.1', '7.1.2', '7.1.3', '7.1.4'], ['7.2.1'], ['7.3.1', '7.3.2', '7.3.3'], ['7.4.1', '7.4.2']]
    ]
  end

  def self.locations
    [['1.1.In front of body', '2.2.In front of face'],
     ['3.3.Head', '3.4.Top of Head', '3.5.Eyes', '3.6.Nose', '3.7.Ear', '3.8.Cheek', '3.9.Lower Head'],
     ['4.0.Body', '4.10.Neck/Throat', '4.11.Shoulders', '4.12.Chest', '4.13.Abdomen', '4.14.Hips/Pelvis/Groin',
      '4.15.Upper Leg'],
     ['5.0.Arm', '5.16.Upper Arm', '5.17.Elbow', '5.18.Lower Arm'],
     ['6.0.Hand', '6.19.Wrist', '6.20.Fingers/Thumb', '6.21.Palm of Hand', '6.22.Back of Hand', '6.23.Blades of Hand']]
  end

  def self.location_groups
    # The first row and the first of each row.
    Sign.locations.map.with_index { |r, i| i.zero? ? r : r[0] }.flatten
  end

  def self.usage_tags
    [['archaic',   1],
     ['neologism', 2],
     ['obscene',   3],
     ['informal',  4],
     ['rare',      5]]
  end

  def self.topic_tags
    [
      ['Actions and activities',                     5],
      ['Animals',                                    7],
      ['Body and appearance',                        9],
      ['Clothes',                                   10],
      ['Colours',                                   11],
      ['Communication and cognition', 6],
      ['Computers',                                 48],
      ['Countries, cities and nationalities',       21],
      ['Deaf-related',                              12],
      ['Direction, location and spatial relations', 13],
      ['Education',                                 17],
      ['Emotions',                                  18],
      ['Events and celebrations',                   14],
      ['Family',                                    20],
      ['Food and drink',                            16],
      ['Government and politics',                   22],
      ['Health',                                    23],
      ['House and garden', 8],
      ['Idioms and phrases',                        24],
      ['Language and Linguistics',                  45],
      ['Law and crime',                             25],
      ['Maori culture and concepts',                26],
      ['Materials',                                 27],
      ['Maths',                                     47],
      ['Miscellaneous',                             44],
      ['Money',                                     28],
      ['Nature and environment',                    19],
      ['Numbers',                                   29],
      ['People and relationships',                  46],
      ['Places',                                    30],
      ['Pronouns',                                  31],
      ['Qualities, description and comparison',     33],
      ['Quantity and measure',                      34],
      ['Questions',                                 35],
      ['Religions',                                 32],
      ['Science',                                   38],
      ['Sex and sexuality',                         36],
      ['Sports, recreation and hobbies',            37],
      ['Time',                                      39],
      ['Travel and transportation',                 40],
      ['Weather',                                   41],
      ['Work',                                      42]]
  end

  private

  def self.search(params)
    xml_document = Nokogiri::XML(open(url_for_search(params)))
    entries = xml_document.css(ELEMENT_NAME)
    count = xml_document.css('totalhits').inner_text.to_i
    [count, entries]
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
