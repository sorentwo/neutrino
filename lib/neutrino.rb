require 'neutrino/storage/null'
require 'neutrino/uploader'
require 'neutrino/version'

module Neutrino
  class << self
    attr_writer :persistence, :processing, :storage

    def configure(&block)
      yield self
    end

    def persistence
      @persistence
    end

    def processing
      @processing
    end

    def storage
      @storage ||= Neutrino::Storage::Null
    end
  end
end
