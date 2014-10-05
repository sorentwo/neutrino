require 'spec_helper'
require 'neutrino/storage/memory'

describe Neutrino::Storage::Memory do
  let(:uploader) { instance_double('Uploader', store_path: '/path/image.jpg') }
  let(:storage)  { Neutrino::Storage::Memory.new(uploader) }
  let(:file)     { StringIO.new('file content') }

  describe '#store' do
    it 'persists an io object in memory' do
      storage.store(file)
      expect(storage.retrieve).to eq(file)
    end
  end

  describe '#delete' do
    it 'clears the object from memory' do
      storage.store(file)
      storage.delete
      expect(storage.retrieve).to be_nil
    end
  end

  describe '#exists?' do
    it 'is true when an object has been stored' do
      expect(storage.exists?).to be_falsey
      storage.store(file)
      expect(storage.exists?).to be_truthy
    end
  end
end
