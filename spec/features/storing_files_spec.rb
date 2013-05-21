require 'spec_helper'

class BasicUploader
  include Neutrino::Uploader

  def store_dir; 'uploads';       end
  def filename;  'text_file.txt'; end
end

describe 'Storing Files' do
  let(:text_file) { File.open('spec/fixtures/text_file.txt', 'r') }

  subject(:uploader) { BasicUploader.new }

  context 'Using null storage', storage: :null do
    it 'does not store a file' do
      expect(uploader.store(text_file)).to be_true
    end
  end

  context 'Using AWS storage', storage: :aws do
    it 'uploads the file to the configured s3 bucket' do
      expect(uploader.store(text_file)).to be_true

      expect(uploader.url).to eq("https://#{ENV.fetch('AWS_BUCKET_NAME')}.s3.amazonaws.com/uploads/text_file.txt")
    end
  end
end
