require 'neutrino/storage/null'
require 'forwardable'

module Neutrino
  class Uploader
    extend Forwardable

    attr_writer :storage

    delegate store!: :storage

    def storage
      @storage ||= Neutrino::Storage::Null.new(self)
    end
  end
end
