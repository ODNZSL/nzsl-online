require 'csv'
def load_pages
  Page.transaction do
    source_path = Rails.root.join('db', 'seeds')
    pages_file = "#{source_path}/pages.csv"
    Rails.logger.info "Loading pages from #{pages_file}..."
    CSV.foreach(pages_file) do |row|
      page = Page.create_from_csv(row)
      Rails.logger.info "\tCreated #{page.slug} page"
    end
  end
  Rails.logger.info 'Finished loading pages'
end

def load_page_parts
  PagePart.transaction do
    source_path = Rails.root.join('db', 'seeds')
    page_parts_file = "#{source_path}/page_parts.csv"
    Rails.logger.info "Loading page parts from #{page_parts_file}..."
    CSV.foreach(page_parts_file) do |row|
      page_part = PagePart.create_from_csv(row)
      Rails.logger.info "\tCreated #{page_part.slug} page_part"
    end
  end
  Rails.logger.info 'Finished loading page parts'
end

def load_settings
  Setting.transaction do
    source_path = Rails.root.join('db', 'seeds')
    settings_file = "#{source_path}/settings.csv"
    Rails.logger.info "Loading settings from #{settings_file}..."
    CSV.foreach(settings_file) do |row|
      setting = Setting.create_from_csv(row)
      Rails.logger.info "\tCreated #{setting.key} setting"
    end
  end
  Rails.logger.info 'Finished loading settings'
end

load_pages
load_page_parts
load_settings
