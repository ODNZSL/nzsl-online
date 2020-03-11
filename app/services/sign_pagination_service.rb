# frozen_string_literal: true

class SignPaginationService # rubocop:disable Metrics/ClassLength
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper

  ##
  # @param [Integer] current_page_number
  # @param [Integer] total_num_results
  # @param [Hash(String => String)] search_query
  #
  def initialize(current_page_number:, total_num_results:, search_query:)
    @current_page_number = current_page_number
    @search_query = search_query
    @total_num_pages = (total_num_results.to_f / Sign::RESULTS_PER_PAGE).ceil
  end

  ##
  # @return [ActiveSupport::SafeBuffer] pagination HTML to show on page
  #
  def pagination_links_html
    pagination_links =
      (1..@total_num_pages)
      .reject { |page_num| page_num_should_be_removed?(page_num) }
      .map { |page_num| prepare_for_presentation(page_num) }

    pagination_links
      .unshift(prev_link)
      .push(next_link)
      .join("\n")
      .html_safe
  end

  private

  def prepare_for_presentation(page_num)
    return wrap_without_link('...')       if page_num_should_be_replaced_with_elipsis?(page_num)
    return wrap_as_current_page(page_num) if current_page?(page_num)

    wrap_with_link(page_num)
  end

  def wrap_as_current_page(page_num)
    wrap_in_li(content_tag(:span, page_num, class: 'current a'))
  end

  def wrap_with_link(page_num, text: page_num)
    wrap_in_li(
      link_to(content_tag(:span, text),
              build_search_path_for(page_num))
    )
  end

  def wrap_without_link(text)
    wrap_in_li(content_tag(:span, text, class: 'a'))
  end

  def wrap_in_li(content)
    content_tag(:li, content)
  end

  def page_num_should_be_removed?(page_num) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/LineLength
    (
      @current_page_number < 5 &&
      page_num > 6 &&
      not_last_page?(page_num)
    ) || (
      @current_page_number > @total_num_pages - 4 &&
      page_num < @total_num_pages - 5 &&
      not_first_page?(page_num)
    ) || (
      @current_page_number > 4 &&
      @current_page_number < @total_num_pages - 3 &&
      more_than_two_pages_away_from_current_page?(page_num) &&
      not_first_page?(page_num) &&
      not_last_page?(page_num)
    )
  end

  def page_num_should_be_replaced_with_elipsis?(page_num) # rubocop:disable Metrics/CyclomaticComplexity
    (
      @current_page_number < 5 &&
      page_num == 6
    ) || (
      @current_page_number > @total_num_pages - 4 &&
      page_num == @total_num_pages - 5
    ) || (
      @current_page_number > 4 &&
      @current_page_number < @total_num_pages - 3 &&
      exactly_two_pages_away_from_current_page?(page_num)
    )
  end

  def prev_link
    return wrap_without_link(I18n.t('pagination.previous')) if current_page_is_first_page?

    wrap_with_link(@current_page_number - 1, text: I18n.t('pagination.previous'))
  end

  def next_link
    return wrap_without_link(I18n.t('pagination.next')) if current_page_is_last_page?

    wrap_with_link(@current_page_number + 1, text: I18n.t('pagination.next'))
  end

  ##
  # @param [Integer] page_num
  # @return [String]
  #
  def build_search_path_for(page_num)
    path_helper_params = @search_query
                         .transform_values { |v| v.is_a?(Array) ? v.join(' ') : v }
                         .merge('p' => page_num)

    Rails.application.routes.url_helpers.search_signs_path(path_helper_params)
  end

  def current_page_is_first_page?
    @current_page_number == 1
  end

  def current_page_is_last_page?
    @current_page_number == @total_num_pages
  end

  def current_page?(page_num)
    @current_page_number == page_num
  end

  def not_first_page?(page_num)
    page_num != 1
  end

  def not_last_page?(page_num)
    page_num != @total_num_pages
  end

  def exactly_two_pages_away_from_current_page?(page_num)
    [@current_page_number + 2, @current_page_number - 2].include?(page_num)
  end

  def more_than_two_pages_away_from_current_page?(page_num)
    page_num > @current_page_number + 2 || page_num < @current_page_number - 2
  end
end
