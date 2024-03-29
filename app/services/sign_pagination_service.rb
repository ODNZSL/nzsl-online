# frozen_string_literal: true

class SignPaginationService
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper

  ##
  # @param [Integer] current_page_number
  # @param [Integer] total_num_results
  # @param [Hash(String => String)] route_params
  #
  def initialize(current_page_number:, total_num_results:, route_params:, page_size: default_page_size)
    @current_page_number = current_page_number
    @route_params = route_params
    @page_size = page_size
    @total_num_pages = (total_num_results.to_f / @page_size).ceil
  end

  ##
  # @return [ActiveSupport::SafeBuffer] pagination HTML to show on page
  #
  def pagination_links_html
    pagination_links =
      (1..@total_num_pages)
      .reject { |page_num| page_num_should_be_removed?(page_num) }
      .map { |page_num| prepare_for_presentation(page_num) }

    # https://api.rubyonrails.org/classes/ActionView/Helpers/OutputSafetyHelper.html#method-i-safe_join
    safe_join([prev_link, pagination_links, next_link], "\n")
  end

  attr_reader :page_size

  private

  def default_page_size
    Rails.application.config.results_per_page
  end

  def prepare_for_presentation(page_num)
    return wrap_without_link('...')       if page_num_should_be_replaced_with_elipsis?(page_num)
    return wrap_as_current_page(page_num) if current_page?(page_num)

    wrap_with_link(page_num)
  end

  def wrap_as_current_page(page_num)
    wrap_in_li(tag.span(page_num, class: 'current a'))
  end

  def wrap_with_link(page_num, text: page_num)
    wrap_in_li(
      link_to(tag.span(text),
              build_search_path_for(page_num))
    )
  end

  def wrap_without_link(text)
    wrap_in_li(tag.span(text, class: 'a'))
  end

  def wrap_in_li(content)
    tag.li(content)
  end

  def page_num_should_be_removed?(page_num)
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

  def page_num_should_be_replaced_with_elipsis?(page_num)
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
    Rails.application.routes.url_helpers.search_signs_path(@route_params.merge(p: page_num))
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
