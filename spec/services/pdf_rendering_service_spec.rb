# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PdfRenderingService do
  subject { described_class.new(from_html: html) }

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

  describe '#render' do
    let(:pdf_file_header_bytes) { '%PDF-1.4' } # PDFs begin with this sequence of bytes
    let(:pdf_file_path) { subject.pdf.file_path }
    let(:first_bytes_in_file) { File.read(pdf_file_path, 8) }

    before { subject.render }

    it 'adds a base tag immediately after the <head> opening tag in the given HTML' do
      expect(subject.html).to match(/<head><base href=/)
    end

    it 'saves a non-empty PDF version of the HTML file to disk' do
      expect(File.exist?(pdf_file_path)).to eq(true)
      expect(File.size(pdf_file_path)).to be > 0
      expect(first_bytes_in_file).to eq(pdf_file_header_bytes)
    end
  end

  describe '#node_chrome_env' do
    around do |example|
      ClimateControl.modify(
        PATH: '/usr/bin',
        HOME: '/app',
        LANG: 'en_US.UTF-8',
        LD_LIBRARY_PATH: '/app/.apt/usr/lib',
        LD_PRELOAD: '/app/vendor/jemalloc/lib/libjemalloc.so',
        DATABASE_URL: 'postgres://secret',
        AWS_SECRET_ACCESS_KEY: 'super-secret',
        HTTP_BASIC_AUTH_PASSWORD: 'staging-password'
      ) { example.run }
    end

    it 'allowlists only the env Chrome/Node need' do
      env = subject.send(:node_chrome_env)

      expect(env).to eq(
        'PATH' => '/usr/bin',
        'HOME' => '/app',
        'LANG' => 'en_US.UTF-8',
        'LD_LIBRARY_PATH' => '/app/.apt/usr/lib'
      )
    end

    it 'excludes jemalloc LD_PRELOAD and application secrets' do
      env = subject.send(:node_chrome_env)

      expect(env).not_to have_key('LD_PRELOAD')
      expect(env).not_to have_key('DATABASE_URL')
      expect(env).not_to have_key('AWS_SECRET_ACCESS_KEY')
      expect(env).not_to have_key('HTTP_BASIC_AUTH_PASSWORD')
    end
  end
end
