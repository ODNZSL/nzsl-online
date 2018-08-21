# frozen_string_literal: true

module VocabSheetHelper
  def vocab_sheet?
    @sheet.blank? || @sheet.items.length.zero? || params[:controller] == 'vocab_sheets' ? nil : 'vocab_sheet_background'
  end

  def vocab_sheet_image_width
    @vocab_sheet_image_width ||= (701.0 / @size - 20).floor # 690 is page width 20 is margins/borders/etc
  end

  def vocab_sheet_image_height
    @vocab_sheet_image_height ||= (vocab_sheet_image_width.to_f * (6.0 / 7)).floor # ratio is 6:7
  end

  def vocab_sheet_label_width
    @vocab_sheet_label_width ||= vocab_sheet_image_width - 10
  end

  def vocab_sheet_label_height
    @vocab_sheet_label_height ||= (vocab_sheet_label_width.to_f * (3.0 / 13)).floor
  end

  def vocab_sheet_label_fontsize
    @vocab_sheet_label_fontsize ||= (vocab_sheet_label_height.to_f / 2).floor
  end

  def vocab_sheet_item_width
    @vocab_sheet_item_width ||= vocab_sheet_image_width + 5
  end

  def vocab_sheet_offset_multiple
    @vocab_sheet_offset_multiple = (
      if @size == 5
        15
      elsif @size == 4
        8
      elsif @size == 3
        6
      elsif @size == 2
        2
      else
        1
      end
    )
  end

  def vocab_sheet_pages
    @vocab_sheet_pages ||= @sheet.blank? || @sheet.items.length.zero? ? 0 : (@sheet.items.length.to_f / vocab_sheet_offset_multiple).ceil # rubocop:disable Metrics/LineLength
  end
end
