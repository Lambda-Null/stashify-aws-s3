# frozen_string_literal: true

require "aws-sdk-s3"
require "rantly/rspec_extensions"
require "securerandom"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Provides facilities, such as management of temporary buckets, which
# are useful for running automated tests.
module SpecUtils
  def self.temp_bucket
    bucket = create_bucket
    yield(bucket)
  ensure
    bucket&.objects&.batch_delete!
    bucket&.delete
  end

  def self.create_bucket
    s3 = Aws::S3::Resource.new
    bucket_name = SecureRandom.uuid
    s3.create_bucket(bucket: bucket_name)
    s3.bucket(bucket_name)
  end
end
