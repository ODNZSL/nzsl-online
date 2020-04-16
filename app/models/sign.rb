# frozen_string_literal: true

##
# A sign in New Zealand Sign Language
#
class Sign
  ##
  # Create a custom error class.
  #
  # * Callers of this class can `rescue` one exception class if they want to
  #   catch **all** possible exceptions from this class.
  # * All uncaught exceptions related to this class are grouped together in
  #   exception monitoring tools.
  #
  class FreelexCommunicationError < StandardError; end

  ELEMENT_NAME = 'entry'
  SIGN_OF_THE_DAY_CACHE_KEY = 'sign-of-the-day'

  # The breakpoints for this app allow a 1x, 2x, 3x, and 4x layout. 12, 24, etc.
  # are the best page numbers for this. Because of performance concerns, I'm
  # starting with 12.
  RESULTS_PER_PAGE = 24

  SIGN_ATTRIBUTES = %i[
    age_groups
    contains_numbers
    drawing
    examples
    gender_groups
    gloss_main
    gloss_maori
    gloss_minor
    gloss_secondary
    handshape
    hint
    id
    inflection
    inflection_manner_and_degree
    inflection_plural
    inflection_temporal
    is_directional
    is_fingerspelling
    is_locatable
    location_name
    one_or_two_handed
    related_to
    usage
    usage_notes
    video
    video_slow
    word_classes
  ].freeze

  ##
  # Class (static) methods
  #
  class << self
    # Fetch a sign for the given ID. The sign is fetched from `Rails.cache` if
    # possible, otherwise it is fetched from Freelex and then cached for later
    # use.
    # @param sign_id [String]
    # @return [Sign] if we could find a sign
    # @return [nil] if we could not find a sign
    def find_by_id_via_cache(sign_id)
      return first(id: sign_id) unless FeatureFlags::StoreVocabSheetItemsInRailsCache.enabled?

      # We use the more verbose `Rails.cache.fetch` and `Rails.cache.write`
      # instead of the more concise `Rails.cache.fetch` because many things could
      # go wrong fetching a sign from Freelex so we only want to write the sign
      # to the cache if we got a valid sign. `Rails.cache.fetch` with the block
      # is not conveient for this because it will **always** write the return
      # value of the block to the cache
      cached_sign_json = Rails.cache.read(sign_id)

      # return immediately if we got a cache hit
      return from_json(cached_sign_json) if cached_sign_json.present?

      # otherwise we had a cache miss
      sign = first(id: sign_id) # attempt to fetch sign from Freelex

      # only write the sign to the cache if we successfully got a sign from Freelex
      if sign.present?
        Rails.cache.write(
          sign_id,
          sign.to_json,
          expires_in: FeatureFlags::StoreVocabSheetItemsInRailsCache.cache_timeout.hours
        )
      end

      sign
    end

    # @param search_query_params [Hash] The search query
    # @return [Sign] if we successfully found a sign
    # @return [nil] if we did not find a sign
    def first(search_query_params)
      signs = all(search_query_params)
      return nil if signs.empty?

      signs.first
    end

    # @param search_query_params [Hash] The search query
    # @return [Array<Sign>]
    def all(search_query_params)
      _count, xml_nodes = search(search_query_params)

      xml_nodes.map do |xml_node|
        SignParser.new(xml_node).build_sign
      end
    end

    # @return [Sign] if we successfully found a sign
    # @return [nil] if we did not find a sign
    def random
      first(random: 1)
    end

    # @return [Sign]
    def sign_of_the_day
      # We use the more verbose `Rails.cache.fetch` and `Rails.cache.write`
      # instead of the more concise `Rails.cache.fetch` because many things could
      # go wrong fetching a sign from Freelex so we only want to write the sign
      # to the cache if we got a valid sign. `Rails.cache.fetch` with the block
      # is not conveient for this because it will **always** write the return
      # value of the block to the cache
      #
      cached_sign_json = Rails.cache.read(SIGN_OF_THE_DAY_CACHE_KEY)

      # return immediately if we had a cache hit
      return from_json(cached_sign_json) if cached_sign_json.present?

      # Otherwise we had a cache miss
      Rails.logger.info('Fetching new random sign from Freelex')
      sign = random # attempt to fetch sign from Freelex

      # only write the sign to the cache if we successfully got a sign from Freelex
      Rails.cache.write(SIGN_OF_THE_DAY_CACHE_KEY, sign.to_json, expires_in: 24.hours) if sign.present?

      sign
    end

    # @param search_query [Hash]
    # @param page_number [Integer]
    # @return [Array(Integer, Array<Sign>)]
    def paginate(search_query_params, page_number)
      start_index = RESULTS_PER_PAGE * (page_number - 1) + 1
      start_index = 1 if start_index < 1

      paginated_query_params = search_query_params.merge(start: start_index, num: RESULTS_PER_PAGE)
      count, xml_nodes = search(paginated_query_params)

      signs =
        xml_nodes.map do |xml_node|
          SignParser.new(xml_node).build_sign
        end

      [count, signs]
    end

    # Creates a new instance of a `Sign` object given a set of JSON attributes.
    # This method is designed to be used as the inverse of `Sign#to_json`
    # @param json [String] JSON representation of a `Sign` as created by `Sign#to_json`
    # @return [Sign] if we successfully found a sign
    # @return [nil] if we did not find a sign
    def from_json(json)
      return nil if json.nil? || json.empty? || json == 'null'

      sign = Sign.new

      JSON.parse(json, symbolize_names: true).each do |attr_name, attr_value|
        sign.public_send("#{attr_name}=", attr_value)
      end

      sign
    end

    private

    # @param [Hash] search_query_params
    # @return [Array<(Integer, Nokogiri::XML::NodeSet)>]
    def search(search_query_params)
      xml_request(search_query_params)
    rescue FreelexCommunicationError => e
      msg = <<~EO_MSG
        Recovered from a failure to retrieve data from Freelex!
          * An empty result-set will be returned to the calling code.
          * Error details:
            #{e}
      EO_MSG

      Rails.logger.warn(msg)
      Raygun.track_exception(e)

      []
    end

    # @param [Hash] search_query_params
    # @return [Array<(Integer, Nokogiri::XML::NodeSet)>]
    def xml_request(search_query_params)
      xml_document = Nokogiri.XML(http_conn.get(query_string_for_search(search_query_params)).body)

      total_num_results_for_query = xml_document.css('totalhits').inner_text.to_i
      result_nodes = xml_document.css(ELEMENT_NAME)

      [total_num_results_for_query, result_nodes]
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

    # @param search_query_params [Hash]
    # @return [String] the URI-safe query string
    def query_string_for_search(search_query_params)
      query_parts = []

      search_query_params.each do |k, v|
        next if v.nil?

        if v.is_a?(Array)
          v.each { |ea| query_parts << "#{k}=#{CGI.escape(ea.to_s)}" if ea.present? }
        else
          query_parts << "#{k}=#{CGI.escape(v.to_s)}"
        end
      end

      "?#{query_parts.join('&')}"
    end

    # @return [Faraday::Connection]
    def http_conn
      Faraday.new(url: SIGN_URL) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.options.timeout = FREELEX_TIMEOUT
        faraday.adapter Faraday.default_adapter
      end
    end
  end

  ##
  # Sign instance methods
  #

  attr_accessor(*SIGN_ATTRIBUTES)

  # @return [nil] if this sign is related to 'nzsl'
  # @return [String] otherwise
  def borrowed_from
    related_to unless related_to == 'nzsl'
  end

  # @return [String] if we find the location
  # @return [nil] otherwise
  def location
    SignMenu.locations.flatten.find { |l| l.split('.')[2].downcase[0, 4] == location_name[0, 4] }
  end
end
