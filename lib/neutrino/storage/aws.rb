require 'aws/s3'

module Neutrino
  module Storage
    class AWS
      class << self
        attr_accessor :acl, :bucket, :access_key_id, :secret_access_key

        def configure(&block)
          yield self
        end
      end

      attr_reader :uploader

      def initialize(uploader)
        @uploader = uploader
      end

      def store(new_file)
        file.write(new_file, {
          acl: self.class.acl,
          content_type: 'application/octet-stream'
        })

        new_file.close unless new_file.closed?

        true
      end

      def delete
        file.delete
      end

      def exists?
        file.exists?
      end

      def url
        file.public_url.to_s
      end

      private

      def bucket
        @bucket ||= connection.buckets[self.class.bucket]
      end

      def connection
        @connection ||= ::AWS::S3.new(credentials)
      end

      def credentials
        { access_key_id:     self.class.access_key_id,
          secret_access_key: self.class.secret_access_key }
      end

      def file
        @file ||= bucket.objects[uploader.store_path]
      end
    end
  end
end
