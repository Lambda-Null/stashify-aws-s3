# frozen_string_literal: true

require "stashify/contract/directory_contract"

require "stashify/directory/aws/s3"

RSpec.describe Stashify::Directory::AWS::S3, aws: true do
  around(:each) do |s|
    SpecUtils.temp_bucket do |bucket|
      @bucket = bucket
      s.run
    end
  end

  include_context "directory setup", 10

  before(:each) do
    @bucket.object(File.join(path, file_name)).put(body: contents)
  end

  subject(:directory) do
    Stashify::Directory::AWS::S3.new(
      bucket: @bucket,
      path: path,
    )
  end

  it_behaves_like "a directory"
end
