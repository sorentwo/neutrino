require 'neutrino'
require 'fileutils'

def source_environment_file!
  return unless File.exists?('.env')

  File.readlines('.env').each do |line|
    values = line.split('=')
    ENV[values.first] = values.last.chomp
  end
end

RSpec.configure do |config|
  config.filter_run :focus
  config.order = 'random'
  config.run_all_when_everything_filtered = true

  config.before do
    Neutrino.reset!
  end

  config.before(storage: :null) do
    require 'neutrino/storage/null'

    Neutrino.configure do |config|
      config.storage = Neutrino::Storage::Null
    end
  end

  config.before(storage: :aws) do
    require 'neutrino/storage/aws'

    Neutrino.configure do |config|
      config.storage = Neutrino::Storage::AWS

      config.storage.configure do |storage|
        storage.acl               = :public_read
        storage.bucket            = ENV.fetch('AWS_BUCKET_NAME')
        storage.access_key_id     = ENV.fetch('AWS_ACCESS_KEY_ID')
        storage.secret_access_key = ENV.fetch('AWS_SECRET_ACCESS_KEY')
      end
    end
  end

  config.before(processing: :image) do
    FileUtils.cp('spec/fixtures/image.png', 'spec/fixtures/backup.png')
  end

  config.after(processing: :image) do
    jpeg_path = 'spec/fixtures/image.jpg'

    FileUtils.rm(jpeg_path) if File.exists?(jpeg_path)
    FileUtils.mv('spec/fixtures/backup.png', 'spec/fixtures/image.png')
  end

  source_environment_file!
end
