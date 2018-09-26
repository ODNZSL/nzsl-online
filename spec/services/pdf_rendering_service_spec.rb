require 'rails_helper'

RSpec.describe PdfRenderingService do
  let(:html) do
    <<~EO_HTML
      <html>
        <head>
          <title>I am title</title>
        </head>
        <body>
          <h1>This is a test document</h1>
        </body>
      </html>
    EO_HTML
  end

  subject { PdfRenderingService.new(from_html: html) }

  describe '#render' do
    let(:pdf_file_header_bytes) { '%PDF-1.4' } # PDFs begin with this sequence of bytes

    it 'adds a base tag immediately after the <head> opening tag in the given HTML' do
      subject.render
      expect(subject.html).to match(/<head><base href=/)
    end

    context 'Saves a PDF version of the HTML file to disk' do
      before do
        subject.render
        @pdf_file_path = subject.pdf.file_path
        @first_bytes_in_file = File.read(@pdf_file_path, 8)
      end

      it { expect(subject.html).to match(/<head><base href=/) }
      it { expect(File.exist?(@pdf_file_path)).to eq(true) }
      it { expect(File.size(@pdf_file_path)).to be > 0 }
      it { expect(@first_bytes_in_file).to eq(pdf_file_header_bytes) }
    end
  end
end
