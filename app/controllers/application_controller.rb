# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include BasicAuthHelper

  protect_from_forgery with: :exception
  require 'browser'
  layout :layout_by_resource

  before_action :check_browser_support
  before_action :http_basic_auth

  private

  def after_sign_in_path_for(_resource)
    admin_path
  end

  def layout_by_resource
    devise_controller? ? 'admin' : 'application'
  end

  def setup_browser_rules # rubocop:disable Metrics/AbcSize
    Browser.modern_rules.clear
    Browser.modern_rules << ->(b) { b.chrome? && b.version.to_i >= 55 }
    Browser.modern_rules << ->(b) { b.firefox? && b.version.to_i >= 51 }
    Browser.modern_rules << ->(b) { b.safari? && b.version.to_i >= 9 }
    Browser.modern_rules << ->(b) { b.ie? && b.version.to_i >= 10 }
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
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def respond_with_json_or_redirect(object, redirect = nil)
    respond_with(object) do |format|
      format.html { redirect ? redirect_to(redirect) : redirect_back_or_default }
      format.js { render text: object.to_json }
    end
  end

  def load_search_query
    # @query = session[:search][:query] if session[:search].present? && session[:search][:query].present?
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
      render template: "pages/#{@page.template}", status: 404
    else
      render text: '404 - page not found', status: 404
    end
  end

  protected

  def check_browser_support
    setup_browser_rules
    return if browser.modern?
    flash[:error] = %(Your browser is not supported. This may mean that some features of NZSL Online will
                      not display properly. <a href="https://updatemybrowser.org/"> Would you like to
                      upgrade your browser? </a>).html_safe
  end

  def http_basic_auth
    return unless staging_env?
    authenticate_or_request_with_http_basic("Username and Password please") do |username, password|
      username == ENV["HTTP_BASIC_AUTH_USERNAME"] && password == ENV["HTTP_BASIC_AUTH_PASSWORD"]
    end
  end
end
