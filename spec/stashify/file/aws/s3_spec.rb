# frozen_string_literal: true

require "stashify/file/aws/s3"

RSpec.describe Stashify::File::AWS::S3, aws: true do
  around(:each) do |s|
    SpecUtils.temp_bucket do |bucket|
      @bucket = bucket
      s.run
    end
  end

  let(:property_count) { 10 }

  let(:properties) do
    property_of do
      path = array(5) do
        dir = string
        guard dir !~ %r{/}
        dir
      end
      [File.join(path), string]
    end
  end

  it "takes an s3 client, bucket name and path for the constructor" do
    properties.check(property_count) do |path, contents|
      @bucket.object(path).put(body: contents)

      file = Stashify::File::AWS::S3.new(bucket: @bucket, path: path)
      expect(file.name).to eq(File.basename(path))
      expect(file.contents).to eq(contents)
    end
  end
end
