require 'neutrino'
require 'forwardable'

module Neutrino
  class Uploader
    extend Forwardable

    attr_writer :storage

    delegate [:store!, :url] => :storage

    def storage
      @storage ||= Neutrino.storage.new(self)
    end
  end
end
