class Admin::PagesController < ApplicationController
  before_filter :get_page, :only => [:edit, :update, :destroy]
  layout 'admin'

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new(:template => 'standard')
  end
 
  def edit
  end
 
  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to admin_pages_path, :notice => 'Page was successfully created.'
    else
      render :action => :new
    end
  end

  def update
    if @page.update_attributes(params[:page])
      redirect_to admin_pages_path, :notice => 'Page was successfully updated.'
    else
      render :action => :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_url
  end
  
  def reorder
    params[:items].each_with_index do |id, index|
      #Need to update updated_at column as update_all doesn't do this for some reason
      Page.where(:id => id.to_i).update_all(
        :order => index + 1,
        :updated_at => Time.now
      )
    end
    render :nothing => true
  end
  
private

  def get_page
    @page = Page.find(params[:id])
  end

end
