class Admin::PagesController < ApplicationController
  before_action :get_page, only: [:edit, :update, :destroy]
  before_action :set_title, :authenticate
  layout 'admin'

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new(template: 'standard')
  end

  def edit
  end

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
      # Need to update updated_at column as update_all doesn't do this for some reason
      Page.where(id: id.to_i).update_all(
        order: index + 1,
        updated_at: Time.now
      )
    end
    render nothing: true
  end

  private

  def get_page
    @page = Page.find(params[:id])
  end

  def set_title
    @title = 'Administrate pages'
  end

  def page_params
    params.require(:page).permit(:title, :slug, :label, :show_in_nav, :template)
  end
end
