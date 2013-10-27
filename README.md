# KeywordCurry

[![Gem Version](https://badge.fury.io/rb/keyword_curry.png)](http://badge.fury.io/rb/keyword_curry)

Augments Ruby currying to handle MRI 2.1 required keyword arguments.

Proc like objects can be curried until all their required keywords have been received

**Please note**:
* Monkey patching is optional.
* Ruby 2.1+ is required.
* Optional keyword arguments cannot be curried.

## Installation

Add this line to your application's Gemfile:

    gem 'keyword_curry'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install keyword_curry

## Usage

### Mnkey patching is optional

This gem merely adds a couple of modules and it's up to you whether you would
like all of your Procs monkey patched.

The monkey patch version
```ruby
require "keyword_curry"

Proc.prepend(KeywordCurry::KeywordArgumentCurrying)
```

You may wish for this behaviour only on special Procs
```ruby
require "keyword_curry"

class SpecialProc < Proc
  include KeywordCurry::KeywordArgumentCurrying

  # ...
end
```

### Currying Examples

```ruby
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
