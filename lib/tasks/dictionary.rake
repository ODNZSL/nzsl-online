namespace :dictionary do # rubocop:disable Metrics/BlockLength
  desc 'Updates the NZSL dictionary packaged with the application to the latest release from Signbank'
  task :update do # rubocop:disable Rails/RakeEnvironment - we need to place this file before the app can start
    database_s3_location = URI.parse(ENV.fetch('DICTIONARY_DATABASE_S3_LOCATION') || '')
    raise 'DICTIONARY_DATABASE_S3_LOCATION must be an S3 URI' unless database_s3_location.scheme == 's3'

    download_s3_uri(database_s3_location, 'db/new-dictionary.sqlite3')

    database = SQLite3::Database.open('db/new-dictionary.sqlite3')
    raise 'Database does not pass integrity check' unless database.integrity_check == [['ok']]

    version = database.get_int_pragma('user_version')

    FileUtils.mv('db/new-dictionary.sqlite3', 'db/dictionary.sqlite3')

    puts "Updated db/dictionary.sqlite3 to #{version}"
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new({
      region: ENV.fetch('DICTIONARY_AWS_REGION', ENV.fetch('AWS_REGION', nil)),
      access_key_id: ENV.fetch('DICTIONARY_AWS_ACCESS_KEY_ID', nil),
      secret_access_key: ENV.fetch('DICTIONARY_AWS_SECRET_ACCESS_KEY', nil)
    }.compact)
  end

  def download_s3_uri(s3_uri, target)
    bucket = s3_uri.host
    key = s3_uri.path[1..]

    begin
      s3_client.get_object({ bucket:, key: }, target:)
    rescue Aws::Errors::MissingCredentialsError,
           Aws::Sigv4::Errors::MissingCredentialsError,
           Aws::S3::Errors::ServiceError

      # Fallback to public-URL download over HTTP if credentials are not provided or invalid.
      # TODO use aws-sdk to leverage aws-client optimizations once unsigned requests are supported:
      # https://github.com/aws/aws-sdk-ruby/issues/1149
      public_url = URI.parse(Aws::S3::Bucket.new(bucket, credentials: 0).object(key).public_url)
      Net::HTTP.start(public_url.host, public_url.port, use_ssl: true) do |http|
        response = http.get(public_url.request_uri).tap(&:value)
        File.binwrite(target, response.body)
      end
    end
  end
end
