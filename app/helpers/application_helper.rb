# frozen_string_literal: true

module ApplicationHelper
  def page_title
    "#{@title}#{' -' if @title} #{t('layout.title')}" # rubocop:disable Rails/HelperInstanceVariable
  end

  def render_navigation_link(link)
    link_to_unless_current(link.label, link.path) do
      tag.span(link.label, class: 'menu-list__selected')
    end
  end

  def submit_button(text = 'search.submit', options = {})
    tag.div(class: 'button input_button') do
      submit_tag(t(text), options.merge(name: nil))
    end
  end

  def submit_search_button
    button_tag(name: nil, class: 'search-button') do
      tag.i('', class: 'fi-magnifying-glass')
    end
  end

  def link_button(text, url, options = {})
    link_options = {
      class: "button #{options[:class]}"
    }.reverse_merge(options)

    link_to(t(text), url, link_options)
  end

  def orange_submit_button(text, url, options = {})
    button = button_tag(t(text), name: nil, class: 'orange_submit_button')
    link_options = {
      class: (options[:class]).to_s
    }.reverse_merge(options)

    link_to(button, url, link_options)
  end

  def play_video_button(text, url = nil, options = {})
    url ||= 'javascript:void(0);'
    link_text = safe_join([tag.i('', class: 'fi-play'), t(text)])
    link_options = { class: "button #{options[:class]}" }.reverse_merge(options)

    link_to(link_text, url, link_options)
  end
end
