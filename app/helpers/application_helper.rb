module ApplicationHelper
  def page_title
    "#{@title}#{' -' if @title} #{t('layout.title')}"
  end

  def render_navigation_link(link)
    link_to_unless_current(link.label, link.path) do
      content_tag :span, link.label
    end
  end

  # def flow_video_tag(source, options = {})
  #   options.symbolize_keys!

  #   source_tag = content_tag(:source, nil, type: 'video/mp4', src: source)
  #   wrapper_class = "flowplayer #{options.delete(:wrapper_class)}"
  #   content_tag(:div, class: wrapper_class) do
  #     content_tag(:video, source_tag, loop: !!options[:loop])
  #   end
  # end

  def flow_video_tag(source, options)
    options.symbolize_keys!

    wrapper_class = "video_replace #{options.delete(:wrapper_class)}"
    content_tag(:a, nil,
                href: source,
                class: wrapper_class,
                data: { loop: options[:loop] })
  end

  def submit_button(text = 'search.submit', options = {})
    "<div class='button input_button'>
      <div class='r'></div>
      #{submit_tag(t(text), options.merge(name: nil))}
     </div>".html_safe
  end

  def submit_search_button
    "<button type='submit' class='search-button'>
      <i class='fi-magnifying-glass'></i>
    </button>".html_safe
  end

  def link_button(text, url = nil, options = {})
    url ||= 'javascript:void(0);'
    link_to "<div class='r'></div>#{t(text)}".html_safe,
            url,
            { class: ("button #{options[:class]}") }.reverse_merge(options)
  end

  def orange_video_button(text, url = nil, options = {})
    url ||= 'javascript:void(0);'
    link_to "<i class='fi-play'></i>#{t(text)}".html_safe,
            url,
            { class: ("orange_video_button #{options[:class]}") }.reverse_merge(options)
  end

  def orange_link_button(text, url = nil, options = {})
    url ||= 'javascript:void(0);'
    link_to "<button type='submit' class='orange_link_button'>
              <span class='icon-container'>
                <i class='fi-plus'></i>
              </span>
              <span class='text-container'>
                #{t(text)}
              </span>
            </button>".html_safe,
            url,
            { class: ("show-for-medium #{options[:class]}") }.reverse_merge(options)
  end

  def div_button(text, options = {})
    content_tag :div, "<div class='r'></div>#{t(text)}".html_safe,
                { class: ("button link_button #{options[:class]}") }.reverse_merge(options)
  end

  def query_for_query_string
    query = @query.dup
    query.each { |k, v| query[k] = v.is_a?(Array) ? v.join(' ') : v }
    HashWithIndifferentAccess.new query
  end

  def print_stylesheet_tag(print)
    # if the url looks like ?print=true
    # change the print button to a back button that's visible on screen but hidden on print.
    if print
      return "#{stylesheet_link_tag('print', media: 'all')}
              #{stylesheet_link_tag('print_screen', media: 'screen')}".html_safe
    else
      return stylesheet_link_tag('print', media: 'print')
    end
  end

  def print_javascripts_tag(print)
    "<script>
      document.printView = true;
    </script>".html_safe if print
  end

  def video_translation(part)
    link_text = (part.page.multiple_page_parts? ? 'play_this_section' : 'play_this_page')
    content_tag :div, [flow_video_tag(asset_path(part.translation_path),
                                      wrapper_class: 'translation_video main_video hidden_video'),
                       orange_video_button(link_text,
                                   nil,
                                   class: 'translation_button float-left')
                      ].join(' ').html_safe,
                class: 'videos clearfix_left'
  end
end
