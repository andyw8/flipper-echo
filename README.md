# Flipper::Echo

This gem adds a simple callback interface for
[Flipper](https://github.com/jnunemaker/flipper) adapter events.

For example, when a Flipper feature is changed, you can:

* send a Slack notification
* write the change to a database or log file
* send a YO

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flipper-echo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flipper-echo

## Usage

First, [configure Flipper](https://github.com/jnunemaker/flipper#usage) as you
normally would (any adapter will do), e.g.:

```ruby
FLIPPER = Flipper.new(Flipper::Adapters::Memory.new)
```

Then configure `Flipper::Echo`:

#### Option 1: handle event with a proc

```ruby
Flipper::Echo.configure do |config|
  config.flipper = FLIPPER

  config.notifier = proc do |event|
    # Do something with the event...
    #
    puts "#{event.feature.name} changed: #{event.action}"
  end
end
```

#### Option 2: handle event with a notifier class

`Flipper::Echo` can also use any object that has a `notify` method:

```ruby
class FlipperNotifier
  def notify(event)
    # Do something with the event...
  end
end

Flipper::Echo.configure do |config|
  config.flipper  = FLIPPER
  config.notifier = FlipperNotifier.new
end
```

## Contributing

1. Fork it ( https://github.com/mode/flipper-echo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
