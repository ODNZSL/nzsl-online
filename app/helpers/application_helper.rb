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
    link_to "<div class='r'></div>#{t(text)}".html_safe, url, {:class => 'button link_button'}.merge(options)
  end
  
  def query_for_query_string
    query = @query.dup
    query.each { |k,v| query[k] = v.is_a?(Array) ? v.join(' ') : v }
    return HashWithIndifferentAccess.new query
  end
  
  def print_stylesheet_tag(print)
    #if the url looks like ?print=true
    # change the print button to a back button that's visible on screen but hidden on print.
    # set the print stylesheet to screen (an excellent preview)
    # bring up the print dialog on load. 
    #booya. 
    if print
      "#{stylesheet_link_tag('print', :media => 'all')}
      <script>
        $(window).bind('load', function(){
          $('.header>.center').prepend($('<a />', {html: '<div class=\"r\"></div>#{t('back')}', click: function(){history.back();return false;}, 'class': 'view_print_back_link button', href:'javascript:void(0);'}))
          window.print();
        });
      </script>
      <style media='screen'>
        .view_print_back_link {display:inline-block !important;}
      </style>".html_safe
    else
      stylesheet_link_tag('print', :media => "print")
    end
  end
  
end
