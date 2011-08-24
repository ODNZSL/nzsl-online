module VocabSheetHelper
  def vocab_sheet?
    @sheet.blank? || @sheet.items.length.zero? || params[:controller] == 'vocab_sheets'? nil : 'vocab_sheet_background'
  end
  def vocab_sheet_image_width
    @vocab_sheet_image_width ||= ((701.0)/@size - 20).floor #690 is page width 20 is margins/borders/etc
  end
  def vocab_sheet_image_height
    @vocab_sheet_image_height ||= (vocab_sheet_image_width.to_f*(6.0/7)).floor #ratio is 6:7
  end
  def vocab_sheet_label_width
    @vocab_sheet_label_width ||= vocab_sheet_image_width - 10
  end
  def vocab_sheet_label_height
    @vocab_sheet_label_height ||= (vocab_sheet_label_width.to_f*(3.0/13)).floor
  end
  def vocab_sheet_label_fontsize
    @vocab_sheet_label_fontsize ||= (vocab_sheet_label_height.to_f/2).floor
  end
  def vocab_sheet_item_width
    @vocab_sheet_item_width ||= vocab_sheet_image_width + 5
  end
  def vocab_sheet_item_height
    @vocab_sheet_item_height ||= 16 + vocab_sheet_image_height + vocab_sheet_label_height
  end
  def vocab_sheet_offset_multiple
    @vocab_sheet_offset_height ||= ((950.to_f / (39 + vocab_sheet_item_height)).floor * @size) #950 is the page height I'm apparently getting away with.
  end
  def vocab_sheet_pages
    @vocab_sheet_pages ||= (@sheet.blank? || @sheet.items.length.zero?) ? 0 : (@sheet.items.length.to_f / vocab_sheet_offset_multiple).ceil
  end
end
