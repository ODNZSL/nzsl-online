class ApplicationController < ActionController::Base
  # protect_from_forgery

private

  def find_or_create_vocab_sheet
    @sheet = VocabSheet.find_by_id(session[:vocab_sheet_id])
    @sheet ||= VocabSheet.create
    session[:vocab_sheet_id] = @sheet.id if @sheet
  end
  
  def find_vocab_sheet
    @sheet = VocabSheet.find_by_id(session[:vocab_sheet_id])
    true
  end
  
  def redirect_back_or_default
    begin
      redirect_to :back
    rescue RedirectBackError
      redirect_to root_path
    end
  end

  def respond_with_json_or_redirect(object, redirect = nil)
    respond_with(object) do |format|
      format.html { redirect ? redirect_to(redirect) : redirect_back_or_default }
      format.js { render :text => object.to_json }
    end
  end
  
  def load_search_query
    #@query = session[:search][:query] if session[:search].present? && session[:search][:query].present?
  end
  
  def set_search_query
    @query = {}
  end
  
  def get_footer_content
    @footer = Page.find(Setting.get(:footer))
  end
  
  def render_404
    if @page = Page.find(Setting.get(:'404'))
      render :template => "pages/#{@page.template}", :status => 404
    else
      render :text => '404 - page not found', :status => 404
    end
    return
  end
  
end

