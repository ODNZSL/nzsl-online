require 'csv'
def load_pages
  Page.transaction do
    source_path = Rails.root.join('db', 'seeds')
    Dir.glob("#{source_path}/pages.csv").each do |pages_file|
      Rails.logger.info "Loading pages from #{pages_file}..."
      CSV.foreach(pages_file) do |row|
        page = Page.create_from_csv(row)
        Rails.logger.info "\tCreated #{page.slug} page"
      end
    end
  end
  Rails.logger.info 'Finished loading pages'
end

def load_page_parts
  PagePart.transaction do
    source_path = Rails.root.join('db', 'seeds')
    Dir.glob("#{source_path}/page_parts.csv").each do |page_parts_file|
      Rails.logger.info "Loading page parts from #{page_parts_file}..."
      CSV.foreach(page_parts_file) do |row|
        page_part = PagePart.create_from_csv(row)
        Rails.logger.info "\tCreated #{page_part.slug} page_part"
      end
    end
  end
  Rails.logger.info 'Finished loading page parts'
end

load_pages
load_page_parts
