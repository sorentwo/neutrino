require 'neutrino/uploader'

describe Neutrino::Uploader do
  let(:uploader) { Neutrino::Uploader.new }

  describe '#storage' do
    it 'defaults to the configured storage engine' do
      expect(uploader.storage).to be_instance_of(storage_class)
    end

    it 'defaults to the null storage engine' do
      expect(uploader.storage).to be_instance_of(Neutrino::Storage::Null)
    end
  end

  describe '#storage=' do
    it 'sets the storage engine to the specified class' do
      engine = double(:storage)
      uploader.storage = engine

      expect(uploader.storage).to eq(engine)
    end
  end
end
