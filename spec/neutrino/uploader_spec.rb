require 'neutrino'
require 'neutrino/uploader'

describe Neutrino::Uploader do
  let(:uploader) { Neutrino::Uploader.new }

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
end
