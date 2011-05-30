module SearchHelper
  # Sign Attribute Image Helpers
  
  def handshape_image number, main=false, simple=false
    return sign_attribute_image :handshape, number, main unless simple
    return sign_attribute_image_tag :handshape, number
  end
  
  def location_image number, main=false, in_menu=false, simple=false
    return sign_attribute_image :location, number, main, in_menu unless simple
    return sign_attribute_image_tag :location, number
  end
  
  def sign_attribute_image attribute, number, main, in_menu=false
    if number
      size = (attribute == :location && in_menu) ? '72' : '42'
      output = content_tag :div, :class => classes_for_sign_attribute(attribute, main) do
        [content_tag(:span, value_for_sign_attribute(number, attribute, main), :class => 'value'),
         image_tag("/images/#{attribute.to_s}s/#{size}/#{attribute.to_s}.#{number.downcase.gsub(/[ \/]/, '_')}.png")].join
      end
      output << number.split('.').last if attribute == :location && in_menu
      output
    end
  end
  
  def sign_attribute_image_tag attribute, number
    image_tag("/images/#{attribute.to_s}s/42/#{attribute.to_s}.#{number.downcase.gsub(/[ \/]/, '_')}.png", :class => 'image')
  end
  
  #these images have been resized with
  # mogrify -negate -alpha copy -negate -resize 42x42 -background transparent -gravity center -extent 42x42 *.png
  # or
  # mogrify -negate -alpha copy -negate -resize 72x72 -background transparent -gravity center -extent 72x72 *.png
  
  # Sign Attribute is Selected?
  
  def handshape_selected?(shape)
    if @query[:hs].present?
      query_hs = @query[:hs]
      # if it's the first, the search is just on the first two numbers
      query_hs = @query[:hs].map {|q| "#{q}.1"} if shape.split('.').last == '1'
      'selected' if query_hs.include?(shape)
    end
  end
  
  def location_selected?(location)
    'selected' if @query[:l].present? && @query[:l].include?(location.split('.')[1])
  end
  def location_group_selected?(location_group)
    'selected' if @query[:lg].present? && @query[:lg].include?(location_group.split('.')[0])
  end
  
  def selected_tab?(tab)
    if params[:tab] == tab.to_s
      'selected'
    elsif params[:tab].blank?
      keys = @query.select{|k,v| v.present? }.keys
      if %w(tag usage).any? {|k| keys.include?(k)} || (keys.include?('s') && keys.length > 1)
        'selected' if tab == :advanced
      elsif %w(hs l lg).any? {|k| keys.include?(k)}
        'selected' if tab == :signs
      else 
        'selected' if tab == :keywords
      end
    end
  end
  
  def display_locations_search_term(simple = false)
    # reduce the list to the selected, turn them all into images. 
    Sign.locations.flatten.select{|l| location_selected?(l) }.map{|l| location_image l, false, simple }.join(' ').html_safe unless @query[:l].blank?
  end
  def display_handshapes_search_term(simple = false)
    Sign.handshapes.flatten.flatten.select{|hs| handshape_selected?(hs) }.map{|hs| handshape_image hs, (hs.split('.').last == '1'), simple }.join(' ').html_safe unless @query[:hs].blank?
  end
  def display_location_groups_search_term(simple = false)
    Sign.location_groups.select{|lg| location_group_selected?(lg)}.map{|lg| location_image lg, true, simple }.join(' ').html_safe unless @query[:lg].blank?
  end
  def display_usage_tag_search_term
    # reduce the list to the selected
    h Sign.usage_tags.select{|u| @query[:usage].include?(u.last.to_s) }.map(&:first).join(' ') unless @query[:usage].blank?
  end
  def display_topic_tag_search_term
    h Sign.topic_tags.select{|u| @query[:tag].include?(u.last.to_s) }.map(&:first).join(' ') unless @query[:tag].blank?
  end

  def search_term(key)
    return if @query[key].blank? || (@query[key].is_a?(Array) && @query[key].reject(&:blank?).blank?)
    h @query[key].join(' ')
  end
  
  def display_search_term
    debugger
    [search_term('s'),
     display_handshapes_search_term(true),
     display_locations_search_term(true),
     display_location_groups_search_term(true),
     display_usage_tag_search_term,
     display_topic_tag_search_term].compact.join(' ').html_safe
    
  end
private
  def value_for_sign_attribute number, attribute, main
    if attribute == :handshape
      if main
        #if it's the first, just search on the first two numbers
        value = number.split('.')[0,2].join('.')
      else
        value = number
      end
    elsif attribute == :location
      if main
        value = number.split('.')[0]
      else
        value = number.split('.')[1]
      end
    end
  end
  def classes_for_sign_attribute attribute, main
    classes = 'image rounded'
    if main
      classes << ' main_image'
    elsif attribute == :handshape
      classes << ' transition'
    end
    classes
  end
end