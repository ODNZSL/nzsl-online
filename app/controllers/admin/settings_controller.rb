class Admin::SettingsController < ApplicationController
  layout 'admin'
  
  def show
    redirect_to edit_admin_settings_path
  end
  
  def edit
  end
  
  def update
    if Setting.update_all(params[:settings])
      flash[:notice] = 'Settings were successfully saved.'
    end
    render :edit
  end
end