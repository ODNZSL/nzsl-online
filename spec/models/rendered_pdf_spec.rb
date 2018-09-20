require 'rails_helper'

RSpec.describe 'RenderedPdf', type: :model do
  subject { RenderedPdf }

  let!(:rendered_pdf) { RenderedPdf.new(file_path: Faker::Internet.url) }

  describe "#download_as_filename" do
    context "with no title provided" do
      it "returns the default pdf title" do
        expect(rendered_pdf.download_as_filename(nil)).to eq("vocab_sheet.pdf")
      end
    end

    context "with a title provided" do
      it "returns the user assigned title as the name of the PDF" do
        expect(rendered_pdf.download_as_filename("My custom pdf")).to eq("My custom pdf.pdf")
      end
    end
  end

end
