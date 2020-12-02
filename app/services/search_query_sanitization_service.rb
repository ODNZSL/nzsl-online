# frozen_string_literal: true

class SearchQuerySanitizationService
  ANYTHING_EXCEPT_NUMBERS_AND_SPACE_REGEX = /[^[[:digit:]] ]+/.freeze
  ANYTHING_EXCEPT_NUMBERS_SPACE_PERIOD_REGEX = /[^[[:digit:]]. ]+/.freeze
  ANYTHING_EXCEPT_NUMBERS_REGEX = /[^[[:digit:]]]+/.freeze
  ANYTHING_EXCEPT_LETTERS_NUMBERS_COMMON_PUNCTUATION_REGEX = /[^[[:alnum:]]āēīōūĀĒĪŌŪ\-() ']+/.freeze

  MAX_QUERY_TERM_LENGTH = 50 # characters

  ##
  # @param [ActionController::Parameters] params
  # @return [Hash]
  #
  def sanitize_for_standard_search(params) # rubocop:disable Metrics/AbcSize
    return {} if params.nil?

    clean_search_term          = sanitize_search_term(params['s'])
    clean_handshape            = sanitize_handshape(params['hs'])
    clean_body_location_fields = sanitize_body_location_fields(params['l'])
    clean_body_location_groups = sanitize_body_location_groups(params['lg'])
    clean_usage                = sanitize_usage(params['usage'])
    clean_tag                  = sanitize_tag(params['tag'])

    result = {}

    result['s']     = [clean_search_term]                   unless clean_search_term.empty?
    result['hs']    = clean_handshape.split(' ')            unless clean_handshape.empty?
    result['l']     = clean_body_location_fields.split(' ') unless clean_body_location_fields.empty?
    result['lg']    = clean_body_location_groups.split(' ') unless clean_body_location_groups.empty?
    result['usage'] = clean_usage.split(' ')                unless clean_usage.empty?
    result['tag']   = clean_tag.split(' ')                  unless clean_tag.empty?

    result
  end

  def sanitize_for_autocomplete_search(term)
    sanitize_search_term(term)
  end

  private

  ##
  # @param [String] term
  # @return [String]
  #
  def sanitize_search_term(term)
    return '' if term.nil?

    term
      .gsub(ANYTHING_EXCEPT_LETTERS_NUMBERS_COMMON_PUNCTUATION_REGEX, '')
      .strip
      .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
  end

  ##
  # @param [String] handshape
  # @return [String]
  #
  def sanitize_handshape(handshape)
    return '' if handshape.nil?

    handshape
      .gsub(ANYTHING_EXCEPT_NUMBERS_SPACE_PERIOD_REGEX, '')
      .strip
      .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
  end

  ##
  # @param [String] body_location_fields
  # @return [String]
  #
  def sanitize_body_location_fields(body_location_fields)
    return '' if body_location_fields.nil?

    body_location_fields
      .gsub(ANYTHING_EXCEPT_NUMBERS_AND_SPACE_REGEX, '')
      .strip
      .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
  end

  ##
  # @param [String] body_location_groups
  # @return [String]
  #
  def sanitize_body_location_groups(body_location_groups)
    return '' if body_location_groups.nil?

    body_location_groups
      .gsub(ANYTHING_EXCEPT_NUMBERS_AND_SPACE_REGEX, '')
      .strip
      .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
  end

  ##
  # @param [String] usage
  # @return [String]
  #
  def sanitize_usage(usage)
    return '' if usage.nil?

    usage
      .gsub(ANYTHING_EXCEPT_NUMBERS_REGEX, '')
      .strip
      .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
  end

  ##
  # @param [String] tag
  # @return [String]
  #
  def sanitize_tag(tag)
    return '' if tag.nil?

    tag
      .gsub(ANYTHING_EXCEPT_NUMBERS_AND_SPACE_REGEX, '')
      .strip
      .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
  end
end
