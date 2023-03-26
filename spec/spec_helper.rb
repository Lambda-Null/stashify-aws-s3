# frozen_string_literal: true

require "aws-sdk-s3"
require "rantly/rspec_extensions"
require "securerandom"

require "stashify/aws/s3"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module SpecUtils
  def self.temp_bucket
    s3_client = Aws::S3::Client.new
    bucket_name = SecureRandom.uuid
    s3_client.create_bucket(bucket: bucket_name)
    yield(s3_client, bucket_name)
  ensure
    delete_all_objects(s3_client, bucket_name)
    s3_client.delete_bucket(bucket: bucket_name) if bucket_name
  end

  def self.delete_all_objects(s3_client, bucket_name)
    s3_client.delete_objects(
      bucket: bucket_name,
      delete: {
        objects: s3_client.list_objects_v2(bucket: bucket_name).contents.map do |object|
          { key: object.key }
        end
      },
    )
  end
end
