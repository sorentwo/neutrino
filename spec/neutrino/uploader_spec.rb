require 'neutrino'
require 'neutrino/uploader'

describe Neutrino::Uploader do
  let(:uploader) do
    Object.new.tap do |object|
      object.extend(Neutrino::Uploader)
    end
  end

  describe '#storage' do
    it 'defaults to the null storage engine' do
      expect(uploader.storage).to be_instance_of(Neutrino.storage)
    end
  end

  describe '#storage=' do
    it 'overrides the configured storage engine' do
      engine = double(:storage)
      uploader.storage = engine

      expect(uploader.storage).to eq(engine)
    end
  end

  describe '#cache' do
    it 'holds a reference to the provided file' do
      file = double(:file)

      uploader.cache(file)
      expect(uploader.cached).to eq(file)
    end
  end
end
