module PaginationHelper
  #This helper is reliant on information stored in the session to get the results total and the page number
  def pagination_links
    total_pages = (session[:search][:count].to_f / Sign::RESULTS_PER_PAGE).ceil
    page = session[:search][:p]
  
    links = pages(page, total_pages)
  
    links.map! do |link_text|
      if link_text == 'previous' && page != 1
        page_link = page - 1
      elsif link_text == 'next' && page != total_pages
        page_link = page + 1
      elsif link_text.is_a?(Numeric) && page != link_text
        page_link = link_text
      end
      if page_link
        content_tag :li, link_to(content_tag(:span, link_text), search_signs_path(session[:search][:query].merge(:p => page_link)))
      else
        content_tag :li, (content_tag :span, link_text, :class => (page == link_text ? 'current a' : 'a'))
      end
    end
    links.join("\n").html_safe
  end

private

  def pages(page, total_pages)
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
        elsif(page < 5 && i == 6) ||
             (page > total_pages - 4 && i == total_pages - 5) ||
             (page > 4 && page < total_pages - 3 && (i == page + 2 || i == page - 2))
          '...'
        else
          i
        end
      end.compact!
    end
    ['previous'] + pages_to_link + ['next']
  end
  
end