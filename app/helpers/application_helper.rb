module ApplicationHelper
  ### TEMP TEMP TEMP
  def videojs_rails(*_args)
    content_tag(:p, 'Sorry, this video is unavailable', class: 'word_gloss', style: 'min-height: 150px')
  end

  def page_title
    "#{@title}#{' -' if @title} #{t('layout.title')}"
  end

  def render_navigation_link(link)
    link_to_unless_current(link.label, link.path) do
      content_tag :span, link.label
    end
  end

  def submit_button(text = 'search.submit', options = {})
    "<div class='button input_button'>
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
    link_to t(text).to_s.html_safe,
            url,
            { class: "button #{options[:class]}" }.reverse_merge(options)
  end

  def orange_submit_button(text, url = nil, options = {})
    url ||= 'javascript:void(0);'
    link_to "<button type='submit' class='orange_submit_button'>
              #{t(text)}
            </button>".html_safe,
            url,
            { class: (options[:class]).to_s }.reverse_merge(options)
  end

  def play_video_button(text, url = nil, options = {})
    url ||= 'javascript:void(0);'
    link_to "<i class='fi-play'></i>#{t(text)}".html_safe,
            url,
            { class: "button #{options[:class]}" }.reverse_merge(options)
  end

  def add_vocab_button(text, url = nil, options = {})
    url ||= 'javascript:void(0);'
    link_to "<button type='submit' class='add_vocab_button'>
              <span class='icon-container'>
                <i class='fi-plus'></i>
              </span>
              <span class='text-container'>
                #{t(text)}
              </span>
            </button>".html_safe,
            url,
            { class: "show-for-medium #{options[:class]}" }.reverse_merge(options)
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
      "#{stylesheet_link_tag('print', media: 'all')}
              #{stylesheet_link_tag('print_screen', media: 'screen')}".html_safe
    else
      stylesheet_link_tag('print', media: 'print')
    end
  end

  def print_javascripts_tag(print)
    '<script> document.printView = true; </script>'.html_safe if print
  end

  def video_translation(part)
    link_text = (part.page.multiple_page_parts? ? 'play_this_section' : 'play_this_page')
    content_tag :div, [flow_video_tag(asset_path(part.translation_path),
                                      wrapper_class: 'translation_video main_video hidden_video'),
                       play_video_button(link_text,
                                         nil,
                                         class: 'translation_button float-left')].join(' ').html_safe,
                class: 'videos clearfix_left'
  end
end
