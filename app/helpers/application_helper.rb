module ApplicationHelper

  def page_title
    return t('layout.title') + (@title ?  " :: " + @title : "")

end

