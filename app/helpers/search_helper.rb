# frozen_string_literal: true

module SearchHelper # rubocop:disable Metrics/ModuleLength
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
    return unless number.present?

    size = attribute == :location && in_menu ? '72' : '42'
    output = content_tag :div, class: classes_for_sign_attribute(attribute, main) do
      [content_tag(:span, value_for_sign_attribute(number, attribute, main), class: 'value'),
       image_tag("#{attribute}s/#{size}/#{attribute}.#{number.downcase.gsub(/[ \/]/, '_')}.png")].join.html_safe # rubocop:disable Style/RegexpLiteral, Layout/LineLength
    end
    output << number.split('.').last if attribute == :location && in_menu
    output
  end

  def sign_attribute_image_tag(attribute, number)
    image_tag("#{attribute}s/42/#{attribute}.#{number.downcase.gsub(/[ \/]/, '_')}.png", class: 'image') # rubocop:disable Style/RegexpLiteral, Layout/LineLength
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
    selected = tab_selected?(classes) if params[:tab].blank?
    # note: comparing as a string, to avoid a DOS ruby bug
    #   # see http://brakemanscanner.org/docs/warning_types/denial_of_service/
    selected = true if classes.map(&:to_s).include?(params[:tab])

    classes << (selected ? :selected : '')
    classes.join(' ')
  end

  def tab_classes
    [
      tab_class(:advanced),
      'clearfix',
      'medium-10',
      'medium-centered',
      'large-8',
      'advanced-search-container',
      'show-for-medium'
    ]
  end

  def tab_selected?(classes)
    keys = @query.select { |_key, value| value.present? }.keys
    selected = if %w(tag usage).any? { |key| keys.include?(key) } || (keys.include?('s') && keys.length > 1)
                 classes.include?(:advanced)
               elsif %w(hs l lg).any? { |key| keys.include?(key) }
                 classes.include?(:signs)
               else
                 classes.include?(:keywords)
               end

    selected
  end

  def display_locations_search_term(simple = false)
    # reduce the list to the selected, turn them all into images.
    locations = SignMenu.locations.flatten.select do |location|
      location_selected?(location)
    end
    return if @query[:l].blank?

    locations = locations.map do |location|
      location_image(
        location,
        false,
        false,
        simple
      )
    end
    locations.join(' ').html_safe
  end

  def display_handshapes_search_term(simple = false)
    selected = SignMenu.handshapes.flatten.flatten.select do |hand_shape|
      handshape_selected?(hand_shape)
    end
    return if @query[:hs].blank?

    selected = selected.map do |hand_shape|
      handshape_image(
        hand_shape,
        hand_shape.split('.').last == '1',
        simple
      )
    end
    selected.join(' ').html_safe
  end

  def display_location_groups_search_term(simple = false)
    locations = SignMenu.location_groups.select do |location_group|
      location_group_selected?(location_group)
    end
    return if @query[:lg].blank?

    locations = locations.map do |location_group|
      location_image(
        location_group,
        true,
        false,
        simple
      )
    end
    locations.join(' ').html_safe
  end

  def display_usage_tag_search_term
    # reduce the list to the selected
    h SignMenu.usage_tags.select { |u| @query[:usage].include?(u.last.to_s) }.map(&:first).join(' ') unless @query[:usage].blank? # rubocop:disable Metrics/LineLength
  end

  def display_topic_tag_search_term
    h SignMenu.topic_tags.select { |u| @query[:tag].include?(u.last.to_s) }.map(&:first).join(' ') unless @query[:tag].blank? # rubocop:disable Metrics/LineLength
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
    # a space is required after the base class names below to ensure that they are
    # properly separated from other classes assigned in the conditionals.
    classes = %w(image rounded)
    classes << 'main_image' if main
    classes << 'transition' if attribute == :handshape
    classes.join(' ')
  end
end
