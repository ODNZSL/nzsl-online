module ApplicationHelper
  def page_title
    return t('layout.title') + (@title ?  " - " + @title : "")
  end

  def static_links
    [{:label => t('static.index'),       :slug => '/'},
     {:label => t('static.nzsl'),        :slug => '/nzsl'},
     {:label => t('static.alphabet'),    :slug => '/alphabet'},
     {:label => t('static.numbers'),     :slug => '/numbers'},
     {:label => t('static.classifiers'), :slug => '/classifiers'},
     {:label => t('static.learning'),    :slug => '/learning'},
     {:label => t('static.about'),       :slug => '/about'},
     {:label => t('static.contact_us'),  :slug => '/feedback/new'},
     {:label => t('static.links'),       :slug => '/links'}]
  end
  
  def render_navigation_link(link)
    link_to_unless_current(link[:label], "#{link[:slug]}") do
      content_tag :span, link[:label]
    end
  end
  
  def submit_button text = 'search.submit', options = {}
    "<div class='button input_button'>
      <div class='r'></div>
      #{submit_tag(t(text), options.merge({:name => nil}))}
     </div>".html_safe
  end
  
  def link_button text, url=nil, options = {}
    url ||='javascript:void(0);'
    link_to "<div class='r'></div>#{t(text)}".html_safe, url, {:class => ("button link_button #{options[:class]}")}.reverse_merge(options)
  end
  
  def div_button text, options = {}
    content_tag :div, "<div class='r'></div>#{t(text)}".html_safe, {:class => ("button link_button #{options[:class]}")}.reverse_merge(options)
  end
  
  def query_for_query_string
    query = @query.dup
    query.each { |k,v| query[k] = v.is_a?(Array) ? v.join(' ') : v }
    return HashWithIndifferentAccess.new query
  end
  
  def print_stylesheet_tag(print)
    # if the url looks like ?print=true
    # change the print button to a back button that's visible on screen but hidden on print.
    if print
      "#{stylesheet_link_tag('print', :media => 'all')}
       #{stylesheet_link_tag('print_screen', :media => 'screen')}".html_safe
    else
      stylesheet_link_tag('print', :media => 'print')
    end
  end
  
  def print_javascripts_tag(print)
    if print
      "<script>
        document.printView = true;
      </script>".html_safe
    end
  end
  
  def video_translation filename, label='play_this_page'
    content_tag :div, 
      [content_tag(:div, '', :href => "/system/videos/#{h filename}.mp4", :class => 'video_replace translation_video main_video hidden_video', :id => "video_#{h filename.gsub('-', '_')}"),
       link_button(label, nil, :class => 'translation_button')].join(' ').html_safe, 
      :class => 'videos clearfix_left'
  end
end
