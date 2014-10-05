module Neutrino
  module Storage
    class Memory
      attr_reader :uploader

      def initialize(uploader)
        @uploader = uploader
        @storage  = {}
      end

      def store(new_file)
        @storage[path] = new_file
      end

      def retrieve
        @storage[path]
      end

      def delete
        @storage.delete(path)
      end

      def exists?
        @storage.key?(path)
      end

      private

      def path
        uploader.store_path
      end
    end
  end
end
