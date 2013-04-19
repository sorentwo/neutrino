require 'spec_helper'
require 'neutrino/storage/aws'

describe 'Storing Files' do
  let(:text_file) { File.open('spec/fixtures/text_file.txt', 'r') }

  context 'Using null storage' do
    before do
      Neutrino.configure do |config|
        config.storage = Neutrino::Storage::Null
      end
    end

    it 'does not store a file' do
      uploader = Neutrino::Uploader.new
      expect(uploader.store!(text_file)).to be_nil
    end

    it 'does not have a real url' do
      uploader = Neutrino::Uploader.new
      expect(uploader.url).to be_nil
    end
  end

  context 'Using AWS storage' do
    before do
      Neutrino.configure do |config|
        config.storage = Neutrino::Storage::AWS

        config.storage.configure do |storage|
          storage.acl               = :public_read
          storage.bucket            = ENV.fetch('AWS_BUCKET_NAME')
          storage.access_key_id     = ENV.fetch('AWS_ACCESS_KEY_ID')
          storage.secret_access_key = ENV.fetch('AWS_SECRET_ACCESS_KEY')
        end
      end
    end

    class BasicUploader < Neutrino::Uploader
      def store_dir; 'uploads';       end
      def filename;  'text_file.txt'; end
    end

    it 'uploads the file to the configured s3 bucket' do
      uploader = BasicUploader.new
      uploader.store!(text_file)

      expect(uploader.url).to eq("https://#{ENV.fetch('AWS_BUCKET_NAME')}.s3.amazonaws.com/uploads/text_file.txt")
    end
  end
end
