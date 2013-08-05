require 'spec_helper'

describe 'Deleting Files' do
  let(:text_file) { File.open('spec/fixtures/text_file.txt', 'r') }

  uploader_class = Class.new do
    include Neutrino::Uploader

    def store_dir; 'uploads';       end
    def filename;  'text_file.txt'; end
  end

  context 'Using null storage', storage: :null do
    it 'does not delete a file' do
      uploader = uploader_class.new

      expect(uploader.delete).to be_nil
    end
  end

  context 'Using AWS storage', storage: :aws do
    it 'deletes the file from the stored location' do
      uploader = uploader_class.new

      uploader.store(text_file)
      uploader.delete

      expect(uploader.exists?).to be_false
    end
  end
end
