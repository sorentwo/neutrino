require 'neutrino'
require 'forwardable'

module Neutrino
  module Uploader
    extend Forwardable

    attr_writer :storage
    attr_reader :cached

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def variants
        @variants ||= {}
      end

      def variant(name, &block)
        variants[name] = Class.new(self) do
          if block_given?
            define_method :process!, &block
          end
        end
      end
    end

    delegate [:delete, :exists?, :store, :retreive, :url] => :storage

    def variants
      self.class.variants
    end

    def storage
      @storage ||= Neutrino.storage.new(self)
    end

    def store_dir
    end

    def filename
    end

    def process!
    end

    def store_path(for_file = filename)
      File.join([store_dir, for_file].compact)
    end

    def cache(file)
      @cached = file
    end
  end
end
