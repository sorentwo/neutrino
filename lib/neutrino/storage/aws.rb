require 'aws/s3'
require 'forwardable'

module Neutrino
  module Storage
    class AWS
      extend Forwardable

      class << self
        attr_accessor :acl, :bucket, :access_key_id, :secret_access_key

        def configure(&block)
          yield self
        end
      end

      attr_reader :uploader

      delegate [:acl, :bucket, :access_key_id, :secret_access_key] => self

      def initialize(uploader)
        @uploader = uploader
      end

      def credentials
        { access_key_id:     access_key_id,
          secret_access_key: secret_access_key }
      end

      def connection
        @connection ||= ::AWS::S3.new(credentials)
      end

      def store!(file)
        File.new(self, uploader).tap do |aws_file|
          aws_file.store(file)
        end
      end

      def retreive!(identifier)
        File.new(self, uploader)
      end

      def url
        File.new(self, uploader).url
      end

      class File
        attr_reader :base, :uploader

        def initialize(base, uploader)
          @base     = base
          @uploader = uploader
        end

        def store(new_file)
          file.write(new_file, {
            acl: base.acl,
            content_type: 'application/octet-stream'
          })

          new_file.close unless new_file.closed?

          true
        end

        def url
          file.public_url.to_s
        end

        private

        def bucket
          @bucket ||= connection.buckets[base.bucket]
        end

        def connection
          base.connection
        end

        def file
          @file ||= bucket.objects[path]
        end

        def path
          uploader.store_path
        end
      end
    end
  end
end
