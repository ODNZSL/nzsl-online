# frozen_string_literal: true

module Admin
  class PagePartsController < ApplicationController
    before_action :authenticate_user!, :fetch_page, :set_title
    before_action :fetch_page_part, only: [:edit, :show, :update, :destroy]
    layout 'admin'
    protect_from_forgery except: [:reorder]

    def index
      @page_parts = @page.page_parts
    end

    def new
      @page_part = PagePart.new(page_id: @page.id)
    end

    def edit; end

    def create
      @page_part = PagePart.new(page_part_params)
      @page_part.page = @page
      if @page_part.save
        redirect_to edit_admin_page_path(@page), notice: 'Page part was successfully created.'
      else
        render action: :new
      end
    end

    def update
      if @page_part.update_attributes(page_part_params)
        redirect_to edit_admin_page_path(@page), notice: 'Page part was successfully updated.'
      else
        render action: :edit
      end
    end

    def destroy
      @page_part.destroy
      redirect_to edit_admin_page_path(@page)
    end

    def reorder
      params[:items].each_with_index do |id, index|
        PagePart.find(id.to_i).update(order: index + 1)
      end
      render nothing: true
    end

    private

    def fetch_page_part
      @page_part = @page.page_parts.find(params[:id])
    end

    def fetch_page
      @page = Page.find(params[:page_id])
    end

    def set_title
      @title = 'Administrate page parts'
    end

    def page_part_params
      params.require(:page_part).permit(:title, :translation_path, :body)
    end
  end
end
