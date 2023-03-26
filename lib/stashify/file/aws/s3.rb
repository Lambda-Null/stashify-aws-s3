# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    module AWS
      class S3 < Stashify::File
        def initialize(s3_client, bucket_name, path)
          @s3_client = s3_client
          @bucket_name = bucket_name
          @path = path
          super(name: ::File.basename(path))
        end

        def contents
          @s3_client.get_object(bucket: @bucket_name, key: @path).body.read
        end
      end
    end
  end
end
