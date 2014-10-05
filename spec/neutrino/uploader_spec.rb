require 'neutrino'
require 'neutrino/uploader'

describe Neutrino::Uploader do
  uploader_class = Class.new do
    include Neutrino::Uploader
  end

  describe '#storage' do
    it 'defaults to the null storage engine' do
      uploader = uploader_class.new

      expect(uploader.storage).to be_instance_of(Neutrino.storage)
    end
  end

  describe '#storage=' do
    it 'overrides the configured storage engine' do
      engine   = double(:storage)
      uploader = uploader_class.new
      uploader.storage = engine

      expect(uploader.storage).to eq(engine)
    end
  end

  describe '#cache' do
    it 'holds a reference to the provided file' do
      file     = double(:file)
      uploader = uploader_class.new

      uploader.cache(file)
      expect(uploader.cached).to eq(file)
    end
  end

  describe '#variants' do
    it 'does not share variants between subclasses' do
      uploader_a = Class.new do
        include Neutrino::Uploader

        variant(:mini)
      end

      uploader_b = Class.new do
        include Neutrino::Uploader
      end

      expect(uploader_a.variants).not_to eq(uploader_b.variants)
      expect(uploader_a.new.variants).not_to eq(uploader_b.new.variants)
    end

    it 'captures the passed processing block' do
      uploader_class = Class.new do
        include Neutrino::Uploader

        variant(:mini) do
          convert! 'jpg'
        end
      end

      uploader = uploader_class.new
      variant  = uploader.variants[:mini]

      expect(variant).to receive(:convert!)

      variant.process!
    end
  end
end
