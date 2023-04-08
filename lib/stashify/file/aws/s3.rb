# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    module AWS
      # An implementation for interacting with files in AWS S3
      # buckets. The constructor needs an instance of Aws::S3::Bucket
      # order to know which bucket to interact with.
      class S3 < Stashify::File
        def initialize(bucket:, path:)
          @bucket = bucket
          super(path: path)
        end

        def contents
          @bucket.object(path).get.body.read
        end

        def write(contents)
          @bucket.object(path).put(body: contents)
        end

        def delete
          @bucket.object(path).delete
        end

        def exists?
          @bucket.object(path).exists?
        end
      end
    end
  end
end
