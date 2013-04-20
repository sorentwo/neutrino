require 'spec_helper'

class BasicUploader < Neutrino::Uploader
  def store_dir; 'uploads';       end
  def filename;  'text_file.txt'; end
end

describe 'Deleting Files' do
  let(:text_file) { File.open('spec/fixtures/text_file.txt', 'r') }

  subject(:uploader) { BasicUploader.new }

  context 'Using null storage', storage: :null do
    it 'does not delete a file' do
      expect(uploader.delete).to be_nil
    end
  end

  context 'Using AWS storage', storage: :aws do
    it 'deletes the file from the stored location' do
      uploader.store(text_file)
      uploader.delete

      expect(uploader.exists?).to be_false
    end
  end
end
