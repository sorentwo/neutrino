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
        object.write(
          acl:          self.class.acl,
          content_type: 'application/octet-stream',
          file:         new_file.path
        )

        true
      end

      def delete
        object.delete
      end

      def exists?
        object.exists?
      end

      def url
        object.public_url.to_s
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

      def object
        @object ||= bucket.objects[uploader.store_path]
      end
    end
  end
end
