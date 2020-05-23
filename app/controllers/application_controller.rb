# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include BasicAuthHelper

  protect_from_forgery with: :exception
  layout :layout_by_resource

  before_action :staging_http_auth

  private

  def after_sign_in_path_for(_resource)
    admin_path
  end

  def layout_by_resource
    devise_controller? ? 'admin' : 'application'
  end

  def find_or_create_vocab_sheet
    @sheet = VocabSheet.find_by(id: session[:vocab_sheet_id])
    @sheet ||= VocabSheet.create
    session[:vocab_sheet_id] = @sheet.id if @sheet
  end

  def find_vocab_sheet
    @sheet = VocabSheet.find_by(id: session[:vocab_sheet_id])
    true
  end

  def redirect_back_or_default
    redirect_back(fallback_location: root_path)
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def respond_with_json_or_redirect(object, redirect = nil)
    respond_with(object) do |format|
      format.html { redirect ? redirect_to(redirect) : redirect_back_or_default }
      format.js { render text: object.to_json }
    end
  end

  def set_search_query
    @query = {}
  end

  def footer_content
    footer = Setting.get(:footer)
    @footer = Page.find(footer) if footer
  end

  def render_404
    @page = Page.find(Setting.get(:'404'))
    if @page
      render template: "pages/#{@page.template}", status: :not_found, formats: :html
    else
      render text: '404 - page not found', status: :not_found
    end
  end

  protected

  def staging_http_auth
    return unless staging_env?

    authenticate_or_request_with_http_basic('Username and Password please') do |username, password|
      username == ENV['HTTP_BASIC_AUTH_USERNAME'] && password == ENV['HTTP_BASIC_AUTH_PASSWORD']
    end
  end
end
