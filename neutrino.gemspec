# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'neutrino/version'

Gem::Specification.new do |spec|
  spec.name          = 'neutrino'
  spec.version       = Neutrino::VERSION
  spec.authors       = ['Parker Selbert']
  spec.email         = ['parker@sorentwo.com']
  spec.homepage      = 'https://github.com/sorentwo/neutrino'
  spec.license       = 'MIT'
  spec.description   = %(An uploader library that embraces modularity and rejects magick)
  spec.summary       = %(
    Neutrino is a ruby uploader library that embraces the spirit of
    CarrierWave, but rejects many of the implementation details and magic.
    Neutrino's aim is to work regardless of framework and with any persistence,
    storage, or processor.
  )

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec',   '~> 3.0'
  spec.add_development_dependency 'aws-sdk', '~> 1.29'
end
