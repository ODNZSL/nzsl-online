# frozen_string_literal: true

class SearchQuerySanitizationService
  ANYTHING_EXCEPT_NUMBERS_PERIOD_REGEX = /[^[[:digit:]].]+/
  ANYTHING_EXCEPT_NUMBERS_REGEX = /[^[[:digit:]]]+/
  ANYTHING_EXCEPT_LETTERS_NUMBERS_COMMON_PUNCTUATION_REGEX = /[^[[:alnum:]]āēīōūĀĒĪŌŪ\-,() ']+/

  MAX_QUERY_TERM_LENGTH = 50 # characters
  DELIMITER = ';;'

  ##
  # @param [ActionController::Parameters] params
  # @return [Hash]
  #
  def sanitize_for_standard_search(params)
    return {} if params.nil?

    result = HashWithIndifferentAccess.new

    result['s']     = [sanitize_search_term(params['s'])].compact_blank
    result['hs']    = sanitize_handshape(params['hs'])
    result['l']     = sanitize_body_location_fields(params['l'])
    result['lg']    = sanitize_body_location_groups(params['lg'])
    result['usage'] = sanitize_usage(params['usage'])
    result['tag']   = sanitize_tag(params['tag'])

    result.compact_blank
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

    handshape.strip
             .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
             .split(DELIMITER)
             .map { |hs| hs.gsub(ANYTHING_EXCEPT_NUMBERS_PERIOD_REGEX, '') }
             .compact_blank
  end

  ##
  # @param [String] body_location_fields
  # @return [String]
  #
  def sanitize_body_location_fields(body_location_fields)
    return '' if body_location_fields.nil?

    body_location_fields.strip
                        .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
                        .split(DELIMITER)
                        .map { |blf| blf.gsub(ANYTHING_EXCEPT_NUMBERS_REGEX, '') }
                        .compact_blank
  end

  ##
  # @param [String] body_location_groups
  # @return [String]
  #
  def sanitize_body_location_groups(body_location_groups)
    return '' if body_location_groups.nil?

    body_location_groups.strip
                        .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
                        .split(DELIMITER)
                        .map { |blg| blg.gsub(ANYTHING_EXCEPT_NUMBERS_REGEX, '') }
                        .compact_blank
  end

  ##
  # @param [String] usage
  # @return [String]
  #
  def sanitize_usage(usage)
    return '' if usage.nil?

    usage.strip
         .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
         .split(DELIMITER)
         .map { |usg| usg.gsub(ANYTHING_EXCEPT_LETTERS_NUMBERS_COMMON_PUNCTUATION_REGEX, '') }
         .compact_blank
  end

  ##
  # @param [String] tag
  # @return [String]
  #
  def sanitize_tag(tag)
    return '' if tag.nil?

    tag.strip
       .truncate(MAX_QUERY_TERM_LENGTH, omission: '')
       .split(DELIMITER)
       .map { |tg| tg.gsub(ANYTHING_EXCEPT_LETTERS_NUMBERS_COMMON_PUNCTUATION_REGEX, '') }
       .compact_blank
  end
end
