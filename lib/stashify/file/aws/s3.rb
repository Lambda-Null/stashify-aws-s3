# frozen_string_literal: true

require "stashify/file"

module Stashify
  class File
    module AWS
      class S3 < Stashify::File
        def initialize(bucket:, path:)
          @bucket = bucket
          super(path: path)
        end

        def contents
          @bucket.object(path).get.body.read
        end
      end
    end
  end
end
