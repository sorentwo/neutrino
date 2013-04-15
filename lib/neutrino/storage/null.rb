module Neutrino
  module Storage
    class Null
      attr_reader :uploader

      def initialize(uploader)
        @uploader = uploader
      end

      def store!(new_file); nil; end
    end
  end
end
