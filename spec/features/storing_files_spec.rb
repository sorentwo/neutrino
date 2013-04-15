require 'spec_helper'

describe 'Storing Files' do
  class BasicUploader < Neutrino::Uploader
  end

  let(:text_file) { StringIO.new }

  context 'Using the default null storage' do
    it 'does not store a file' do
      uploader = BasicUploader.new
      expect(uploader.store!(text_file)).to be_nil
    end
  end
end
