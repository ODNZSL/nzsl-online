# frozen_string_literal: true

module VocabSheetHelper
  def vocab_sheet?
    @sheet.blank? || @sheet.items.length.zero? || params[:controller] == 'vocab_sheets' ? nil : 'vocab_sheet_background'
  end

  def vocab_sheet_offset_multiple
    @vocab_sheet_offset_multiple = (
      return offsets[:"size_#{@size}"] if @size.present?
      offsets[:default]
    )
  end

  def vocab_sheet_pages
    @vocab_sheet_pages ||= @sheet.blank? || @sheet.items.length.zero? ? 0 : (@sheet.items.length.to_f / vocab_sheet_offset_multiple).ceil # rubocop:disable Metrics/LineLength
  end

  def vocab_sheet_max_field_length
    100
  end

  private

  def offsets
    {
      size_6: 3,
      size_5: 15,
      size_4: 12,
      size_3: 6,
      size_2: 4,
      size_1: 1,
      default: 1
    }
  end
end
