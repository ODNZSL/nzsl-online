class PdfRenderingService
  class Error < StandardError; end
  class MissingChromeBinaryError < Error; end
  class ChromeTimeoutError < Error; end

  # Create a place for us to work under the Rails `tmp/` dir
  TMP_DIR_PATH = Rails.root.join("tmp", "pdf_rendering").to_s.freeze

  # Set a maximum amount of time we will allow Chrome to attempt to render the
  # PDF
  PDF_CONVERSION_TIMEOUT_SECONDS = 30 # seconds

  attr_reader :pdf, :html

  def initialize(from_html:)
    @html = from_html

    # We create some temporary files and we want to use a consistent unique
    # prefix for their names because it makes debugging easier if we can easily
    # associate the input HTML and the output PDF
    @unique_id = calculate_unique_id

    # @pdf is filled in by the #render method
    @pdf = nil
  end

  def render
    # mutate @html in place (for performance reasons)
    mutate_html_by_inserting_base_tag

    # Create our temp dir if it does not already exist
    create_tmp_dir_if_required

    # Do some gardening on the temp dir to stop it filling the disk. We choose
    # to do this inline because, although it does impact the performance of
    # generating PDFs, that is not a big deal and having this code manage its
    # own temp dir is much easier than coordinating background jobs to manage
    # it.
    TempDirJanitorService.new(tmp_dir_path: TMP_DIR_PATH).remove_old_files

    # Create some empty temporary files
    pdf_path = create_empty_pdf_file
    html_path = create_empty_html_file

    # Write the HTML we received to a file for Chrome to consume (Chrome does
    # not support rendering from STDIN)
    write_to_file(html_path, @html)

    # Convert the HTML file into a PDF and store it in the given pdf_path
    render_as_pdf(input_html_path: html_path, output_pdf_path: pdf_path)

    # Finally we build the RenderedPdf instance which represents the results of
    # our work to the rest of the system
    @pdf = RenderedPdf.new(file_path: pdf_path)
  end

  private

  def write_to_file(path, contents)
    File.write(path, contents)
  end

  def calculate_unique_id
    "#{Time.zone.now.to_i}-#{SecureRandom.hex(10)}"
  end

  def create_empty_html_file
    path = File.join(TMP_DIR_PATH, "#{@unique_id}-input.html")
    FileUtils.touch(path)
    path
  end

  def create_empty_pdf_file
    path = File.join(TMP_DIR_PATH, "#{@unique_id}-output.pdf")
    FileUtils.touch(path)
    path
  end

  def render_as_pdf(input_html_path:, output_pdf_path:)
    cmd = "node #{Rails.root.join("bin", "render-pdf.js")} #{input_html_path} #{output_pdf_path}"
    Rails.logger.info(cmd)

    error_msg = "Chrome did not complete the PDF conversion within the #{PDF_CONVERSION_TIMEOUT_SECONDS} second timeout"

    Timeout.timeout(PDF_CONVERSION_TIMEOUT_SECONDS, ChromeTimeoutError, error_msg) do
      system(cmd)
    end
  end

  def create_tmp_dir_if_required
    FileUtils.mkdir_p(TMP_DIR_PATH) unless Dir.exist?(TMP_DIR_PATH)
  end

  def google_chrome_path
    case Gem::Platform.local.os
    when "darwin" # macOS
      Shellwords.escape("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
    when "linux"
      Shellwords.escape("google-chrome-stable")
    else
      fail MissingChromeBinaryError
    end
  end

  def mutate_html_by_inserting_base_tag
    # @html is potentially a very large string so we deliberately choose to
    # mutate it in place with #sub! instead of making a new copy with #sub for
    # performance reasons.
    #
    # We add the <base ... /> tag just after <head> - it must be added before
    # any <style> or <script></script> tags.
    @html.sub!(/#{Regexp.quote("<head>")}/, "<head>#{base_tag}")
  end

  def base_tag
    domain = Rails.application.secrets.app_domain_name
    protocol = Rails.application.secrets.app_protocol

    "<base href='#{protocol}://#{domain}'/>"
  end
end
