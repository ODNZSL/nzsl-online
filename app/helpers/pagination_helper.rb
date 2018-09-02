# frozen_string_literal: true

module PaginationHelper
  # This helper is reliant on information stored in the session to get the results total and the page number
  def pagination_links # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    pages(@page_number, total_pages).map do |link_text|
      if link_text.is_a?(Numeric) && @page_number != link_text
        link_to_page = link_text
      elsif link_text == t('pagination.previous') && @page_number != 1
        link_to_page = @page_number - 1
      elsif link_text == t('pagination.next') && @page_number != total_pages
        link_to_page = @page_number + 1
      end
      if link_to_page
        content_tag :li, link_to(content_tag(:span, link_text),
                                 search_signs_path(query_for_query_string.merge(p: link_to_page)))
      else
        content_tag :li, (content_tag :span, link_text, class: (@page_number == link_text ? 'current a' : 'a'))
      end
    end.join("\n").html_safe
  end

  def page_of_pages
    "page #{@page_number} of #{total_pages}" if total_pages > 1
  end

  private

    def total_pages
      (@results_total.to_f / Sign::RESULTS_PER_PAGE).ceil
    end

    def pages(page, total_pages) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, MethodLength, LineLength
      # 1 [2] 3
      # [1] 2 3 4 5 6 7
      # [1] 2 3 4 5 ... 8
      # 1 2 3 [4] 5 ... 8
      # 1 ... 4 [5] 6 7 8
      # 1 ... 4 5 6 7 [8]
      # 1 ... 4 [5] 6 ... 9
      # 1 ... 7 [8] 9 ... 12

      pages_to_link = (1..total_pages).to_a
      if total_pages > 7
        pages_to_link.map! do |i|
          if (page < 5 && i > 6 && i != total_pages) ||
             (page > total_pages - 4 && i < total_pages - 5 && i != 1) ||
             (page > 4 && page < total_pages - 3 && (i > page + 2 || i < page - 2) && i != 1 && i != total_pages)
            nil
          elsif (page < 5 && i == 6) ||
                (page > total_pages - 4 && i == total_pages - 5) ||
                (page > 4 && page < total_pages - 3 && (i == page + 2 || i == page - 2))
            '...'
          else
            i
          end
        end.compact!
      end
      [t('pagination.previous')] + pages_to_link + [t('pagination.next')]
    end
end
