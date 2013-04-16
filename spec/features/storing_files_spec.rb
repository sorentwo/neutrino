require 'spec_helper'

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
end
