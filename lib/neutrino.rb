require 'neutrino/storage/null'
require 'neutrino/uploader'
require 'neutrino/version'

module Neutrino
  class << self
    attr_writer :persistence, :processing, :storage

    def configure(&block)
      yield self
    end

    def reset!
      configure do |config|
        config.persistence = nil
        config.processing  = nil
        config.storage     = nil
      end
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
