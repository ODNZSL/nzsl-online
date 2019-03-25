# frozen_string_literal: true

##
# A sign in New Zealand Sign Language
#
class Sign # rubocop:disable Metrics/ClassLength
  # Create a custom error class.
  #
  # * Callers of this class can `rescue` one exception class if they want to
  #   catch **all** possible exceptions from this class.
  # * All uncaught exceptions related to this class are grouped together in
  #   exception monitoring tools.
  #
  class FreelexCommunicationError < StandardError; end

  ELEMENT_NAME = 'entry'

  # The breakpoints for this app allow a 1x, 2x, 3x, and 4x layout. 12, 24, etc.
  # are the best page numbers for this. Because of performance concerns, I'm
  # starting with 12.
  RESULTS_PER_PAGE = 24

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
    send(all_or_first, params) if %i[all first].includes(all_or_first)
  end

  def self.random
    first(random: 1)
  end

  def self.sign_of_the_day # rubocop:disable Metrics/AbcSize
    Rails.cache.fetch('sign-of-the-day', expires_in: 24.hours) do
      Rails.logger.debug('Fetching new random sign from Freelex')
      random
    end
  rescue StandardError => e
    raise e if Rails.env.test? || Rails.env.development?

    Raygun.track_exception(Exception.new("Recovered from sign-of-the-day cache lookup error. error=#{e.inspect}"))
    random
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
    xml_request(params)
  rescue FreelexCommunicationError => e
    msg = <<~EO_MSG
      Recovered from a failure to retrieve data from Freelex!
        * An empty result-set will be returned to the calling code.
        * Error details:
          #{e}
    EO_MSG

    Rails.logger.warn(msg)
    Raygun.track_exception(e)

    [0, []]
  end

  def self.xml_request(params)
    xml_document = Nokogiri::XML(http_conn.get(uri_for_search(params)).body)
    entries = xml_document.css(ELEMENT_NAME)
    count = xml_document.css('totalhits').inner_text.to_i
    [count, entries]
  rescue Faraday::ConnectionFailed
    raise(FreelexCommunicationError, "Failed to connect to Freelex at URL: '#{SIGN_URL}'")
  rescue Faraday::TimeoutError
    raise(FreelexCommunicationError, 'Connection timeout')
  rescue Faraday::Error
    raise(FreelexCommunicationError, 'Generic communication error')
  rescue Nokogiri::SyntaxError
    raise(FreelexCommunicationError, 'Failed to parse response')
  rescue StandardError => e
    raise(FreelexCommunicationError, "Failed to communicate with Freelex because #{e}")
  end

  def self.uri_for_search(query)
    # The handling of arrays in query strings is different
    # in the API than in rails
    return SIGN_URL unless query.is_a?(Hash)

    '?' + query_string_for_search(query).join('&')
  end

  def self.query_string_for_search(query)
    query_string = []
    query.each do |k, v|
      if v.is_a?(Array)
        v.each { |ea| query_string << "#{k}=#{CGI.escape(ea.to_s)}" if ea.present? }
      elsif v.present?
        query_string << "#{k}=#{CGI.escape(v.to_s)}"
      end
    end
    query_string
  end

  def self.http_conn
    Faraday.new(url: SIGN_URL) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects
      faraday.options.timeout = FREELEX_TIMEOUT
      faraday.adapter Faraday.default_adapter
    end
  end
end
