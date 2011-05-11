module VocabSheetHelper
  def vocab_sheet?
    @sheet.blank? || @sheet.items.length.zero? || params[:controller] == 'vocab_sheets'? nil : 'vocab_sheet_background'
  end
end
