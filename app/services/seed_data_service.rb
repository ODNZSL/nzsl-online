# frozen_string_literal: true

class SeedDataService
  def self.load_all
    load_data(:settings)
    load_data(:pages)
    load_data(:page_parts)
  end

  def self.load_data(data_type)
    data_klass = data_type.to_s.singularize.camelize.constantize
    data_klass.transaction do
      CSV.foreach(csv_filename(data_type)) do |row|
        model = data_klass.create_from_csv!(row)
        Rails.logger.info "\tCreated #{data_type} #{model}"
      end
    end
    Rails.logger.info("Finished loading #{data_type}")
    ActiveRecord::Base.connection.reset_pk_sequence!(data_type)
  end

  def self.csv_filename(data_type)
    filename = Rails.root.join('db', 'seeds', "#{data_type.to_s.pluralize}.csv")
    Rails.logger.info "Loading settings from #{filename}..."
    filename
  end
end
