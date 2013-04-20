module Neutrino
  module Storage
    class Null
      attr_reader :uploader

      def initialize(uploader)
        @uploader = uploader
      end

      def delete;          nil;  end
      def store(new_file); true; end
      def url;             nil;  end
    end
  end
end
