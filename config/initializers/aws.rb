secrets = Rails.application.secrets

Aws.config.update(region: 'us-east-1',
                  credentials: Aws::Credentials.new(secrets.aws_access_key_id, secrets.aws_secret_access_key))
S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])
S3_BUCKET_URL = secrets.s3_bucket_url
