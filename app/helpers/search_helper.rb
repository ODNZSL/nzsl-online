module SearchHelper # rubocop:disable ModuleLength
  # Sign Attribute Image Helpers

  def handshape_image(number, main = false, simple = false)
    return sign_attribute_image_tag :handshape, number if simple

    sign_attribute_image :handshape, number, main
  end

  def location_image(number, main = false, in_menu = false, simple = false)
    return sign_attribute_image_tag :location, number if simple

    sign_attribute_image :location, number, main, in_menu
  end

  def sign_attribute_image(attribute, number, main, in_menu = false)
    return unless number

    size = (attribute == :location && in_menu) ? '72' : '42'
    output = content_tag :div, class: classes_for_sign_attribute(attribute, main) do
      [content_tag(:span, value_for_sign_attribute(number, attribute, main), class: 'value'),
       image_tag("#{attribute}s/#{size}/#{attribute}.#{number.downcase.gsub(/[ \/]/, '_')}.png")].join.html_safe # rubocop:disable Style/RegexpLiteral, LineLength
    end
    output << number.split('.').last if attribute == :location && in_menu
    output
  end

  def sign_attribute_image_tag(attribute, number)
    image_tag("#{attribute}s/42/#{attribute}.#{number.downcase.gsub(/[ \/]/, '_')}.png", class: 'image') # rubocop:disable Style/RegexpLiteral, LineLength
  end

  # these images have been resized with
  # mogrify -negate -alpha copy -negate -resize 42x42 -background transparent -gravity center -extent 42x42 *.png
  # or
  # mogrify -negate -alpha copy -negate -resize 72x72 -background transparent -gravity center -extent 72x72 *.png

  # Sign Attribute is Selected?

  def handshape_selected?(shape)
    return unless @query[:hs].present?
    query_hs = @query[:hs]

    # if it's the first, the search is just on the first two numbers
    query_hs = @query[:hs].map { |q| "#{q}.1" } if shape.split('.').last == '1'

    'selected' if query_hs.include?(shape)
  end

  def location_selected?(location)
    'selected' if @query[:l].present? && @query[:l].include?(location.split('.')[1])
  end

  def location_group_selected?(location_group)
    'selected' if @query[:lg].present? && @query[:lg].include?(location_group.split('.')[0])
  end

  def tab_class(*classes)
    if params[:tab].blank?
      selected = tab_selected?(classes)
    else
      # note: comparing as a string, to avoid a DOS ruby bug
      # see http://brakemanscanner.org/docs/warning_types/denial_of_service/
      selected = true if classes.map(&:to_s).include?(params[:tab])
    end

    classes << (selected ? :selected : '')
    classes.join(' ')
  end

  def tab_selected?(classes)
    keys = @query.select { |_k, v| v.present? }.keys
    if %w(tag usage).any? { |k| keys.include?(k) } || (keys.include?('s') && keys.length > 1)
      selected = classes.include?(:advanced)
    elsif %w(hs l lg).any? { |k| keys.include?(k) }
      selected = classes.include?(:signs)
    else
      selected = classes.include?(:keywords)
    end

    selected
  end

  def display_locations_search_term(simple = false)
    # reduce the list to the selected, turn them all into images.
    locations = SignMenu.locations.flatten.select do |l|
      location_selected?(l)
    end

    locations.map { |l| location_image l, false, false, simple }.join(' ').html_safe unless @query[:l].blank?
  end

  def display_handshapes_search_term(simple = false)
    selected = SignMenu.handshapes.flatten.flatten.select do |hs|
      handshape_selected?(hs)
    end

    # rubocop:disable Style/BlockDelimiters
    selected.map { |hs|
      handshape_image hs, (hs.split('.').last == '1'), simple
    }.join(' ').html_safe unless @query[:hs].blank?
    # rubocop:enable Style/BlockDelimiters
  end

  def display_location_groups_search_term(simple = false)
    locations = SignMenu.location_groups.select { |lg| location_group_selected?(lg) }
    locations.map { |lg| location_image lg, true, false, simple }.join(' ').html_safe unless @query[:lg].blank?
  end

  def display_usage_tag_search_term
    # reduce the list to the selected
    h SignMenu.usage_tags.select { |u|
      @query[:usage].include?(u.last.to_s)
    }.map(&:first).join(' ') unless @query[:usage].blank?
  end

  def display_topic_tag_search_term
    h SignMenu.topic_tags.select { |u|
      @query[:tag].include?(u.last.to_s)
    }.map(&:first).join(' ') unless @query[:tag].blank?
  end

  def search_term(key)
    return if @query[key].blank? || (@query[key].is_a?(Array) && @query[key].reject(&:blank?).blank?)
    h @query[key].join(' ')
  end

  def display_search_term
    @display_search_term ||= [search_term('s'),
                              display_handshapes_search_term(true),
                              display_locations_search_term(true),
                              display_location_groups_search_term(true),
                              display_usage_tag_search_term,
                              display_topic_tag_search_term].compact.join(' ').html_safe
  end

  private

  def value_for_sign_attribute(number, attribute, main)
    if attribute == :handshape
      # if it's the first, just search on the first two numbers
      return number.split('.')[0, 2].join('.') if main
      return number
    end

    return unless attribute == :location

    # location
    return number.split('.')[0] if main

    number.split('.')[1]
  end

  def classes_for_sign_attribute(attribute, main)
    classes = 'image rounded'
    if main
      classes << ' main_image'
    elsif attribute == :handshape
      classes << ' transition'
    end
    classes
  end
end
