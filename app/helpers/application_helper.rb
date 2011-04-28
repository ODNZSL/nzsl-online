module ApplicationHelper
  def page_title
    return t('layout.title') + (@title ?  " - " + @title : "")
  end

  def last_search_query
    begin
      return session[:search][:query][:s]
    rescue
      return nil
    end
  end
  
  def static_links
    [{:label => 'Home',        :slug => ''},
     {:label => 'About NZSL',  :slug => 'nzsl'},
     {:label => 'Alphabet',    :slug => 'alphabet'},
     {:label => 'Numbers',     :slug => 'numbers'},
     {:label => 'Classifiers', :slug => 'classifiers'},
     {:label => 'Learning',    :slug => 'learning'},
     {:label => 'About Us',    :slug => 'about'},
     {:label => 'Contact Us',  :slug => 'contact-us'},
     {:label => 'Links',       :slug => 'links'}]
  end
  
  def render_navigation_link(link)
    link_to_unless_current(link[:label], "/#{link[:slug]}") do
      content_tag :span, link[:label]
    end
  end
  
  def submit_button text = 'search.submit'
    "<div class='button'>
      <div class='r'></div>
      #{submit_tag(t(text), :name => nil)}
     </div>".html_safe
  end
end