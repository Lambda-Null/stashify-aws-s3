# frozen_string_literal: true

require "stashify/directory"
require "stashify/file/aws/s3"

module Stashify
  class Directory
    module AWS
      class S3 < Stashify::Directory
        attr_reader :bucket, :path

        def initialize(bucket:, path:)
          @bucket = bucket
          super(path: path)
        end

        def files
          @bucket.objects.map do |object|
            file(::File.basename(object.key))
          end
        end

        def delete(name)
          if directory?(name)
            subdir = directory(name)
            subdir.files.each { |file| subdir.delete(file.name) }
          else
            @bucket.object(path_of(name)).delete
          end
        end

        def ==(other)
          self.class == other.class && @bucket == other.bucket && path == other.path
        end

        private

        def write_file(file)
          @bucket.object(path_of(file.name)).put(body: file.contents)
        end

        def directory?(name)
          @bucket.objects(prefix: path_of(name, "")).count.positive?
        end

        def directory(name)
          Stashify::Directory::AWS::S3.new(bucket: @bucket, path: path_of(name))
        end

        def file?(name)
          @bucket.object(::File.join(path, name)).exists?
        end

        def file(name)
          Stashify::File::AWS::S3.new(bucket: @bucket, path: ::File.join(path, name))
        end
      end
    end
  end
end
