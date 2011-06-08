class VocabSheetsController < ApplicationController

  before_filter :find_or_create_vocab_sheet
  respond_to :html, :json
  def show
  end
  
  def update
    @sheet.name = params[:vocab_sheet][:name]
    if @sheet.save
      flash[:notice] = t('vocab_sheet.sheet.update_success')
    else
      flash[:error] = t('vocab_sheet.sheet.update_failure')
    end
    if request.xhr?
      flash[:notice] = nil
      flash[:error] = nil
      render :text => @sheet.name
    else
      respond_with_json_or_redirect(@sheet)
    end
  end
  
  def destroy
    if @sheet.destroy
      session[:vocab_sheet_id] = nil
      flash[:notice] = t('vocab_sheet.delete_success')
    else
      flash[:error] = t('vocab_sheet.delete_failure')
    end
    redirect_back_or_default
  end
end

