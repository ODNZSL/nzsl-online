class VocabSheetsController < ApplicationController

  before_filter :find_or_create_vocab_sheet

  def show

  end

  def destroy
    @sheet.destroy
  end
end

