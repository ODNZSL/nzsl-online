module SignsHelper

  #This helper is reliant on information stored in the session to get the 'total' number of results.
  #From the stored query though, it can get the start number, and the number of results, so can
  #work out the page number
  def pagination_links(options = {})
    options.reverse_merge!(:id => 'pagination')
    required_session_values = [
      session[:search][:count].to_i,
      session[:search][:query]["num"].to_i,
      session[:search][:query]["start"].to_i
    ]
    return content_tag :ul, "", options unless required_session_values.select { |value| value.zero? }.empty?
    total_results, per_page = session[:search][:count].to_i, session[:search][:query]["num"].to_f
    total_pages = (total_results / per_page.to_f).round
    current_page = Sign.current_page(
      per_page,
      ((params[:page] || session[:search][:query]["start"]).to_i + session[:search][:query]["num"].to_i) - 1,
      total_results
    )
    pagination_items = []
    total_pages.times do |index|
      index = index + 1
      if index == current_page
        pagination_items << content_tag(:li, index.to_s, :class => 'selected')
      else
        pagination_items << content_tag(:li, link_to(index.to_s, search_signs_path(:search => session[:search][:query], :page => index)))
      end
    end
    return content_tag :ul, pagination_items.join("\n").html_safe, options
  end

end

