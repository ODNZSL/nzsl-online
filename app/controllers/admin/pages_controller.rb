# frozen_string_literal: true

module Admin
  class PagesController < ApplicationController
    before_action :fetch_page, only: %i(edit update destroy)
    before_action :authenticate_user!, :set_title
    layout 'admin'
    protect_from_forgery except: [:reorder]

    def index
      @pages = Page.all
    end

    def new
      @page = Page.new(template: 'standard')
    end

    def edit; end

    def create
      @page = Page.new(page_params)
      if @page.save
        redirect_to admin_pages_path, notice: 'Page was successfully created.'
      else
        render action: :new
      end
    end

    def update
      if @page.update_attributes(page_params)
        redirect_to admin_pages_path, notice: 'Page was successfully updated.'
      else
        render action: :edit
      end
    end

    def destroy
      @page.destroy
      redirect_to admin_pages_path
    end

    def reorder
      params[:items].each_with_index do |id, index|
        Page.find(id.to_i).update(order: index + 1)
      end
      render nothing: true
    end

    private

    def fetch_page
      @page = Page.find(params[:id])
    end

    def set_title
      @title = 'Administrate pages'
    end

    def page_params
      params.require(:page).permit(:title, :slug, :label, :show_in_nav, :template)
    end
  end
end
