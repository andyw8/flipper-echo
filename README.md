# Flipper::Echo

This is a fork of the deleted repo previously at https://github.com/mode/flipper-echo

# Description

This gem adds a simple callback interface for
[Flipper](https://github.com/jnunemaker/flipper) adapter events.

For example, when a Flipper feature is changed, you can:

* send a Slack notification (built-in)
* write the change to a database or log file
* notify a performance monitoring application
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

Then configure this gem in any of the following ways:

#### Handle event with a proc

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

#### Handle event with an object

You can provide any Ruby object with a `notify` method:

```ruby
class CustomNotifier
  def notify(event)
    # Do something with the event...
  end
end

Flipper::Echo.configure do |config|
  config.flipper  = FLIPPER
  config.notifier = CustomNotifier.new
end
```

#### Configure multiple notifiers

```ruby
Flipper::Echo.configure do |config|
  config.flipper = FLIPPER

  config.notifiers << NewrelicNotifier.new
  config.notifiers << GraphiteNotifier.new
  config.notifiers << Flipper::Echo::Stdout::Notifier.new
end
```

## Built-in notifiers

#### Slack

First [create a Slack webhook url](https://slack.com/services/new/incoming-webhook),
then use it in your configuration:

```ruby
Flipper::Echo.configure do |config|
  config.notifiers << Flipper::Echo::Slack::Notifier.new(
    'https://hooks.slack.com/your/webhook...', channel: '#eng')
end
```

![Slack example 1](https://s3-us-west-2.amazonaws.com/mode.production/flipper-echo/prod-search-admins.png)

![Slack example 2](https://s3-us-west-2.amazonaws.com/mode.production/flipper-echo/prod-risky-actors.png)

![Slack example 3](https://s3-us-west-2.amazonaws.com/mode.production/flipper-echo/staging-rolled-out-removed.png)

## Documentation

[http://www.rubydoc.info/github/mode/flipper-echo/master](http://www.rubydoc.info/github/mode/flipper-echo/master)

## Contributing

1. Fork it ( https://github.com/mode/flipper-echo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Actual screenshots

![Newrelic example 1](https://s3-us-west-2.amazonaws.com/mode.production/flipper-echo/actual-newrelic-screenshot.png)
