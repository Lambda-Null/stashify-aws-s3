# frozen_string_literal: true

require "stashify/contract/file_contract"

require "stashify/file/aws/s3"

RSpec.describe Stashify::File::AWS::S3, aws: true do
  around(:each) do |s|
    SpecUtils.temp_bucket do |bucket|
      @bucket = bucket
      s.run
    end
  end

  include_context "file setup", 10

  before(:each) do
    @bucket.object(path).put(body: contents)
  end

  subject(:file) do
    Stashify::File::AWS::S3.new(
      bucket: @bucket,
      path: path,
    )
  end

  it_behaves_like "a file"
end
