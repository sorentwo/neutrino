require 'spec_helper'
require 'neutrino/processing/nano'

describe 'Processing Files', processing: :image do
  uploader_class = Class.new do
    include Neutrino::Uploader, Neutrino::Processing::Nano

    def store_dir; 'uploads';   end
    def filename;  'image.png'; end

    def process!
      resize!  '100x100'
      convert! 'jpg'
    end
  end

  it 'applies processing directives when process! is called directly' do
    uploader = uploader_class.new
    image    = File.open('spec/fixtures/image.png')

    uploader.cache(image)
    uploader.process!

    expect(File.extname(uploader.cached)).to eq('.jpg')
  end

  it 'applies processing directives before storage'
  it 'aborts storing when processing fails'
end
