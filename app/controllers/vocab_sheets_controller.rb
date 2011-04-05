class VocabSheetsController < ApplicationController

  before_filter :find_or_create_vocab_sheet

  def show

  end

  def destroy
    if @sheet.destroy && session[:sign_id] = nil
      flash[:notice] = t('vocab_sheet.delete_success')
    else
      flash[:error] = t('vocab_sheet.delete_failure')
    end
  end
end

