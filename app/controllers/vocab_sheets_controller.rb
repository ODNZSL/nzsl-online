class VocabSheetsController < ApplicationController
  before_action :set_vocab_sheet, only: :destroy
  before_action :find_or_create_vocab_sheet, :set_title, except: :destroy
  before_action :set_search_query, :footer_content
  respond_to :html, :json

  def show
    @size = params[:size].to_i
    @size = session[:vocab_sheet_size].to_i if @size.zero?
    @size = 4 if @size.zero?
    session[:vocab_sheet_size] = @size
  end

  def update
    if @sheet.update(vocab_sheet_params)
      flash[:notice] = t('vocab_sheet.sheet.update_success')
    else
      flash[:error] = t('vocab_sheet.sheet.update_failure')
    end

    return respond_with_json_or_redirect(@sheet) unless request.xhr?

    flash[:notice] = flash[:error] = nil
    render json: @sheet
  end

  def destroy
    if @sheet && @sheet.destroy
      session[:vocab_sheet_id] = nil
      flash[:notice] = t('vocab_sheet.delete_success')
    else
      flash[:error] = t('vocab_sheet.delete_failure')
    end
    redirect_back_or_default
  end

  private

  def vocab_sheet_params
    params.require(:vocab_sheet).permit(:name)
  end

  def set_vocab_sheet
    # session object isn't available in the parent controller scope
    session[:vocab_sheet_id] = params[:id] if session[:vocab_sheet_id].blank?
    @sheet = VocabSheet.find_by(id: session[:vocab_sheet_id])
  end

  def set_title
    @title = @sheet.name
  end
end
