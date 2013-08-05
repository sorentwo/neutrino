require 'spec_helper'

describe 'Storing Files' do
  let(:text_file) { File.open('spec/fixtures/text_file.txt', 'r') }

  uploader_class = Class.new do
    include Neutrino::Uploader

    def store_dir; 'uploads';       end
    def filename;  'text_file.txt'; end
  end

  context 'Using null storage', storage: :null do
    it 'does not store a file' do
      uploader = uploader_class.new

      expect(uploader.store(text_file)).to be_true
    end
  end

  context 'Using AWS storage', storage: :aws do
    it 'uploads the file to the configured s3 bucket' do
      uploader = uploader_class.new

      expect(uploader.store(text_file)).to be_true
      expect(uploader.url).to eq("https://#{ENV.fetch('AWS_BUCKET_NAME')}.s3.amazonaws.com/uploads/text_file.txt")
    end
  end
end
