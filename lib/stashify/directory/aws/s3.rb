# frozen_string_literal: true

require "stashify/directory"
require "stashify/file/aws/s3"

module Stashify
  class Directory
    module AWS
      # An implementation for interacting with AWS S3 buckets as if
      # they had directories with "/" as a path separator. In
      # addition to a path, it also needs a Aws::S3::Bucket object
      # representing the bucket the file resides within.
      class S3 < Stashify::Directory
        attr_reader :bucket, :path

        def initialize(bucket:, path:)
          @bucket = bucket
          super(path: path)
        end

        def parent
          Stashify::Directory::AWS::S3.new(
            bucket: @bucket,
            path: ::File.dirname(path),
          )
        end

        def files
          @bucket.objects.map do |object|
            key = object.key
            file(::File.basename(key)) if key =~ %r{^#{Regexp.escape(path)}/([^/]*)(/.*)?$}
          end.compact
        end

        def directory?(name)
          @bucket.objects(prefix: path_of(name, "")).count.positive?
        end

        def directory(name)
          Stashify::Directory::AWS::S3.new(bucket: @bucket, path: path_of(name))
        end

        def exists?(name)
          @bucket.object(::File.join(path, name)).exists?
        end

        def file(name)
          Stashify::File::AWS::S3.new(bucket: @bucket, path: ::File.join(path, name))
        end

        def ==(other)
          self.class == other.class && @bucket == other.bucket && path == other.path
        end
      end
    end
  end
end
