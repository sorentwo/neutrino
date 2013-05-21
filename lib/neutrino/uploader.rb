require 'neutrino'
require 'forwardable'

module Neutrino
  module Uploader
    extend Forwardable

    attr_writer :storage
    attr_reader :cached

    delegate [:delete, :exists?, :store, :url] => :storage

    def storage
      @storage ||= Neutrino.storage.new(self)
    end

    def store_dir
    end

    def filename
    end

    def store_path(for_file = filename)
      File.join([store_dir, for_file].compact)
    end

    def cache(file)
      @cached = file
    end
  end
end
