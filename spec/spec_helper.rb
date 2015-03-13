# encoding: utf-8
#
require 'simplecov'
SimpleCov.start

require 'bundler/setup'
Bundler.setup

require 'flipper/echo'

Dir['./spec/support/**/*.rb'].each(&method(:require))

RSpec.configure do |config|
  config.include AdapterSupport
end
