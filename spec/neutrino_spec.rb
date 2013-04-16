require 'neutrino'

describe Neutrino do
  describe '.configure' do
    let(:custom_module) { double(:custom_module) }

    after { reset_configuration! }

    it 'overrides the default engines' do
      Neutrino.configure do |config|
        config.persistence = custom_module
        config.processing  = custom_module
        config.storage     = custom_module
      end

      expect(Neutrino.persistence).to be(custom_module)
      expect(Neutrino.processing).to be(custom_module)
      expect(Neutrino.storage).to be(custom_module)
    end
  end

  describe '.storage' do
    it 'defaults to the null storage engine' do
      expect(Neutrino.storage).to be(Neutrino::Storage::Null)
    end
  end

  private

  def reset_configuration!
    Neutrino.configure do |config|
      config.persistence = nil
      config.processing  = nil
      config.storage     = nil
    end
  end
end
