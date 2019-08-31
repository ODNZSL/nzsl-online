# frozen_string_literal: true

##
# A sign in New Zealand Sign Language
#
class Sign # rubocop:disable Metrics/ClassLength
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
        Rails.cache.write(sign_id,
                          sign.to_json,
                          expires_in: FeatureFlags::StoreVocabSheetItemsInRailsCache.cache_timeout.hours)
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
    def all(search_query_params) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      if FeatureFlags::StoreAllSignsInRailsCache.disabled?
        Rails.logger.info 'SIGN_CACHE: Caching Sign objects is disabled'
        return search(search_query_params).map { |xml_node| SignParser.new(xml_node).build_sign }
      end

      # The query string we send Freelex is an ideal cache key
      cache_key = query_string_for_search(search_query_params)
      expiry = FeatureFlags::StoreAllSignsInRailsCache.cache_timeout.hours
      log_prefix = "SIGN_CACHE: Key: '#{cache_key}' Message:"

      Rails.logger.info "#{log_prefix} Starting search"

      search_results_json = Rails.cache.fetch(cache_key, expires_in: expiry) do |_key|
        Rails.logger.info "#{log_prefix} Fetching new signs"

        search(search_query_params)
          .map { |xml_node| SignParser.new(xml_node).build_sign }
          .to_json
      end

      Rails.logger.info "#{log_prefix} Converting JSON signs to Sign objects"
      many_from_json(search_results_json)
    rescue StandardError
      # Try fetching the sign without the cache if something went wrong
      search(search_query_params).map { |xml_node| SignParser.new(xml_node).build_sign }
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
    def paginate(search_query, page_number)
      start_index = RESULTS_PER_PAGE * (page_number - 1) + 1
      start_index = 1 if start_index < 1
      paginated_query = search_query.merge(start: start_index, num: RESULTS_PER_PAGE)
      signs = all(paginated_query)

      [signs.length, signs]
    end

    # Creates a new instance of a `Sign` object given a set of JSON attributes.
    # This method is designed to be used as the inverse of `Sign#to_json`
    # @param json [String] JSON representation of a `Sign` as created by `Sign#to_json`
    # @return [Sign] if we successfully found a sign
    # @return [nil] if we did not find a sign
    def from_json(json)
      return nil if json.nil? || json.empty? || json == 'null'

      sign = Sign.new

      # We need `symbolize_names: true` when parsing the JSON because some
      # attributes have nested Hashes and the rest of the app expects these to
      # have Symbol keys
      JSON
        .parse(json, symbolize_names: true)
        .each do |attr_name, attr_value|
          sign.public_send("#{attr_name}=", attr_value)
        end

      sign
    rescue JSON::ParserError
      nil
    end

    # Creates a array of a `Sign` objects given a JSON String representing that array.
    # @param json [String] JSON representation of an array of `Sign` objects
    # @return [Array<Sign>] if we successfully converted the JSON
    # @return [[]] if there were no signs in the JSON or there was some problem with the JSON
    def many_from_json(json)
      return [] if json.nil? || json.empty? || json == 'null' || json == '[]'

      # We need `symbolize_names: true` when parsing the JSON because some
      # attributes have nested Hashes and the rest of the app expects these to
      # have Symbol keys
      JSON
        .parse(json, symbolize_names: true)
        .map do |sign_attrs|
          sign = Sign.new
          sign_attrs.each do |attr_name, attr_value|
            sign.public_send("#{attr_name}=", attr_value)
          end
          sign
        end
    rescue JSON::ParserError
      []
    end

    private

    # @param [Hash] search_query_params
    # @return [Nokogiri::XML::NodeSet] if the search was successful
    # @return [[]] if there was an error
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
    # @return [Nokogiri::XML::NodeSet]
    def xml_request(search_query_params)
      xml_document = Nokogiri::XML(http_conn.get(query_string_for_search(search_query_params)).body)
      xml_document.css(ELEMENT_NAME)
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
