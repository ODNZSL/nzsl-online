# frozen_string_literal: true

module VocabSheetHelper
  def vocab_sheet?
    return nil if @sheet.blank? # rubocop:disable Rails/HelperInstanceVariable
    return nil if @sheet.items.empty? # rubocop:disable Rails/HelperInstanceVariable
    return nil if params[:controller] == 'vocab_sheets'

    'vocab_sheet_background'
  end

  def vocab_sheet_offset_multiple
    return offsets[:"size_#{@size}"] if @size.present? # rubocop:disable Rails/HelperInstanceVariable

    offsets[:default]
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
