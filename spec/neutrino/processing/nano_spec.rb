require 'neutrino/processing/nano'

describe Neutrino::Processing::Nano, processing: :image do
  let(:file) { File.open('spec/fixtures/image.png') }

  subject(:processor) do
    Object.new.tap do |object|
      object.extend(Neutrino::Processing::Nano)
      object.cached = file
    end
  end

  describe '#convert!' do
    it 'converts the file to the new format' do
      processor.convert!('jpg')

      expect(File.extname(processor.cached)).to eq('.jpg')
    end

    it 'cleans up the original file' do
      processor.convert!('jpg')

      expect(File.exists?(file.path)).to be_falsey
    end

    it 'does not delete the original file if the format has not changed' do
      processor.convert!('png')

      expect(File.exists?(file.path)).to be_truthy
    end
  end

  describe '#resize!' do
    it 'resizes the image using the exact dimensions' do
      processor.resize!('100x100')

      expect(`identify #{file.path}`.split(' ')[2]).to eq('100x100')
    end
  end
end
