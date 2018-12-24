class AutocompleteSearchService
  MAX_NUM_SUGGESTIONS = 10
  AUTOCOMPLETE_SEARCH_TIMEOUT = 10 # seconds

  ##
  # @param [String] search_term
  # @param [Faraday::Connection] faraday_connection - has a sensible default value which can be overridden by test code
  # @param [Logger] logger - has a sensible default value which can be overridden by test code
  #
  def initialize(search_term:, faraday_connection: build_faraday_connection, logger: Rails.logger)
    @search_term = search_term
    @faraday_connection = faraday_connection
    @logger = logger
  end

  ##
  # Find MAX_NUM_SUGGESTIONS suggested completions for the given search term.
  #
  # @return [Array<String>] array of autocomplete suggestions
  #
  def find_suggestions # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    response = @faraday_connection.get do |request|
      request.params[:limit] = MAX_NUM_SUGGESTIONS
      request.params[:q] = CGI.escape(@search_term)
    end

    results = response.body.split("\n")

    if results.length > MAX_NUM_SUGGESTIONS
      msg = <<~EO_MSG
        Received #{results.count} autocomplete suggestions (#{results.count - MAX_NUM_SUGGESTIONS} more than expected):
          #{results}
      EO_MSG

      @logger.info(msg)
    end

    results.take(MAX_NUM_SUGGESTIONS)
  rescue Faraday::Error => e
    msg = <<~EO_MSG
      Recovered from failed autocomplete search.
        * Search term was: #{@search_term}
        * Error details:
          #{e}
    EO_MSG
    @logger.warn(msg)

    []
  end

  private

  def build_faraday_connection
    Faraday.new(url: AUTOCOMPLETE_URL) do |faraday|
      # log all requests to stdout in development
      faraday.response :logger if Rails.env.development?

      faraday.use FaradayMiddleware::FollowRedirects
      faraday.options.timeout = AUTOCOMPLETE_SEARCH_TIMEOUT
      faraday.adapter Faraday.default_adapter
    end
  end
end
