require 'spec_helper'
require 'neutrino/processing/nano'

class BasicUploader
  include Neutrino::Uploader, Neutrino::Processing::Nano

  def store_dir; 'uploads';   end
  def filename;  'image.png'; end

  def process!
    resize!  '100x100'
    convert! 'jpg'
  end
end

describe 'Processing Files' do
  before do
    FileUtils.cp('spec/fixtures/image.png', 'spec/fixtures/backup.png')
  end

  after do
    jpeg_path = 'spec/fixtures/image.jpg'
    FileUtils.rm(jpeg_path) if File.exists?(jpeg_path)
    FileUtils.mv('spec/fixtures/backup.png', 'spec/fixtures/image.png')
  end

  it 'applies processing directives to the file before storage' do
    uploader = BasicUploader.new
    image    = File.open('spec/fixtures/image.png')

    uploader.cache(image)
    uploader.process!

    expect(File.extname(uploader.cached)).to eq('.jpg')
  end
end
