module ApplicationHelper

  def page_title
    return t('layout.title') + (@title ?  " :: " + @title : "")
  end

  def last_search_query
    begin
      return session[:search][:query][:s]
    rescue
      return nil
    end
  end

end

