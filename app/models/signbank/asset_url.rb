module Signbank
  class AssetURL
    attr_reader :asset_url

    class S3Adapter
      cattr_accessor :region, :access_key_id, :secret_access_key, :endpoint
      self.region = ENV.fetch('DICTIONARY_AWS_REGION', ENV.fetch('AWS_REGION', nil))
      self.access_key_id = ENV.fetch('DICTIONARY_AWS_ACCESS_KEY_ID', nil)
      self.secret_access_key = ENV.fetch('DICTIONARY_AWS_SECRET_ACCESS_KEY', nil)
      self.endpoint = 's3.amazonaws.com'

      def initialize(asset)
        @asset = asset
      end

      def self.configured?
        region && access_key_id && secret_access_key && client
      end

      def self.client
        @client ||= Aws::S3::Client.new(region:, access_key_id:,
                                        secret_access_key:)
      rescue Aws::Errors::MissingCredentialsError, Aws::Errors::MissingRegionError
        nil
      end

      def bucket_name
        bucket_name, hostname = @asset.asset_url.host.split('.', 2)
        raise ArgumentError, "Invalid hostname #{@asset.asset_url.host}" unless hostname == endpoint

        bucket_name
      end

      def url(expires_in: 1.hour)
        return unless self.class.configured?

        object_key =  @asset.asset_url.path[1..]

        URI.parse(
          Aws::S3::Object.new(bucket_name, object_key, client: self.class.client)
          .presigned_url(:get, expires_in: expires_in.to_i)
        )
      end
    end

    class PassthroughUrlAdapter
      def initialize(asset)
        @asset = asset
      end

      def self.configured?
        true
      end

      def url(*)
        return unless self.class.configured?

        @asset.asset_url
      end
    end

    delegate :url, to: :@adapter

    def initialize(asset_url, adapter: nil)
      @asset_url = URI.parse(asset_url)
      @adapter = (adapter || [S3Adapter, PassthroughUrlAdapter].find(&:configured?)).new(self)
    end
  end
end
