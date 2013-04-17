require 'neutrino'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus
  config.order = 'random'
  config.run_all_when_everything_filtered = true

  config.before do
    Neutrino.reset!
  end
end
