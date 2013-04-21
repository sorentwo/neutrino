# Neutrino

[![Build Status](https://travis-ci.org/sorentwo/neutrino.png?branch=master)](https://travis-ci.org/sorentwo/neutrino)
[![Code Climate](https://codeclimate.com/github/sorentwo/neutrino.png)](https://codeclimate.com/github/sorentwo/neutrino)

Neutrino is a ruby uploader library that embraces the spirit of CarrierWave,
but rejects many of the implementation details and magic. Neutrino's aim is to
work regardless of framework and with any persistence, storage, or processor.

## Disclaimer

Neutrino is under active development and is by no means stable. Classes and
methods documented in this README are not necessarily implemented yet. When a
gem is distributed and/or the version is at least `0.1.0` the gem can be
considered in beta.

## Configuration

Neutrino must be configured to handle persistence, storage, or processing.
Engine configuration uses classes rather than symbols so that any component may
be substituted for a custom library without the need to modify or extend any of
Neutrino's internal classes.

```ruby
# Note that neutrino does not load any engines without an explicit require, you
# must include any engine you need for configuration.
require 'neutrino/persistence/active_model'
require 'neutrino/processing/nano'
require 'neutrino/storage/aws'

Neutrino.configure do |config|
  config.persistence = Neutrino::Persistence::ActiveModel
  config.processing  = Neutrino::Processing::Nano
  config.storage     = Neutrino::Storage::AWS

  config.storage.configure do |storage|
    storage.bucket            = 'bucket.name'
    storage.acl               = :public_read
    storage.access_key_id     = 'access key id'
    storage.secret_access_key = 'secret access key'
  end
end
```

# Mounting

An uploader can be mounted on any ruby object automatically, or it can be
handled manually.

Automatic mounting, identical to CarrierWave syntax. Mounting will only define
a reader and writer, it does not automatically eval in callbacks, validation,
or any additional methods.

```ruby
class User
  include Neutrino::Mountable

  mount_uploader AvatarUploader, :avatar
end
```

Uploaders can also be mounted 'manually' simply by composing them into a class.
This is all that the automatic mounter is doing, but allows you to add custom
behavior to the method.

```ruby
class User
  def avatar
    avatar_uploader.stored
  end

  def avatar=(new_avatar)
    avatar_uploader.stored=(new_avatar)
  end

  def avatar_uploader
    AvatarUploader.new(self, mounted_on: :avatar)
  end
end
```

# Persistence

Having a mounted uploader is nice and all, but you need persistence to retreive
the asset later. As with mounting there are a couple of ways that you can
implement persistence.

```ruby
Neutrino.configure do |config|
  config.auto_persist = true
end
```

The built in ActiveRecord engine will define lifecylce callbacks to handle
storing, tempfile cleanup, and destruction. You would manually define the
callbacks like this:

```ruby
class User < ActiveRecord::Base
  before_validation -> |user| { user.avatar_uploader.validate }
  before_save       -> |user| { user.avatar_uploader.store }
  after_save        -> |user| { user.avatar_uploader.cleanup }
  before_destroy    -> |user| { user.avatar_uploader.destroy }
end
```

## Processing

More often than not processing refers to image processing, though it can be any
post upload asset processing. Asset processing is performed by a set of
`process` directives, each applied in sequence.

```ruby
class AvatarUploader < Neutrino::Uploader
  process resize_to_fit: [120, 120]
  process convert_to:    'jpg'
end
```

## Versions

Defining multiple versions of an asset is simple and modeled directly off of
CarrierWave's style.

```ruby
class AvatarUploader < Neutrino::Uploader
  version(:thumb) do |thumb|
    process resize_to_fit: [120, 120]
  end
end
```

## Testing

Performing asset processing during testing is unnecessary and slow. It is
recommended that you set the global processor to `Neutrino::Processors::Null`
in your testing config.

```ruby
require 'neutrino/processors/null'

Neutrino.configure do |config|
  config.processor = Neutrino::Processors::Null
end
```

Alternatively you can set the processor for any particular uploader during
runtime:

```ruby
uploader = AvatarUploader.new(some_model)
uploader.processor = Neutrino::Processors::Null
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'neutrino', '~> 0.1.0'
```

## Contributing

Feature specs are dependent on at least one external service (AWS) and the
specs won't run unless some environment variables are configured. Please copy
the `.env.sample` file and fill in real credentials to ensure integration specs
are working properly.

```bash
cp .env.sample .env
```

Travis builds are configured to use secure environment variables so that AWS
integration specs will operate. Those variables are *not* available for pull
requests, so all pull requests will fail to pass CI. If and when I get any real
pull requests I'll implement some feature detection to prevent blanekt CI
failures.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
