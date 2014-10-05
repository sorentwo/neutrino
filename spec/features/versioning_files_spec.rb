require 'spec_helper'
require 'neutrino/processing/nano'

describe 'Versioning Files' do
  uploader_class = Class.new do
    include Neutrino::Uploader, Neutrino::Processing::Nano

    def store_dir; 'uploads';   end
    def filename;  'image.png'; end

    variant(:mini) do
      resize!  '32x32'
      convert! 'jpg'
    end

    variant(:thumb) do
      resize!  '100x100'
      convert! 'jpg'
    end
  end

  it 'stores and processes multiple variants of a file' do
    uploader = uploader_class.new
    image    = File.open('spec/fixtures/image.png')

    uploader.cache(image)
    uploader.processs!
  end
end
