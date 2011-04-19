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
    [link_to('Home', '/home'),
     link_to('About NZSL', '/about'),
     link_to('Alphabet', '/alphabet'),
     link_to('Numbers', '/numbers'),
     link_to('Classifiers', '/classifiers'),
     link_to('Learning', '/learning'),
     link_to('About Us', '/about'),
     link_to('Contact Us', '/contact-us'),
     link_to('Links', '/links')]
  end
end

