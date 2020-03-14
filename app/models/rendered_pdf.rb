# frozen_string_literal: true

class RenderedPdf
  attr_reader :file_path

  def initialize(file_path:)
    @file_path = file_path
  end

  def download_as_filename(title)
    title ? "#{title}.pdf" : 'vocab_sheet.pdf'
  end

  def mime_type
    'application/pdf'
  end
end
