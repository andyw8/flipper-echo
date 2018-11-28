# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flipper/echo/version'

Gem::Specification.new do |spec|
  spec.name          = 'flipper-echo'
  spec.version       = Flipper::Echo::VERSION
  spec.authors       = ['Heather Rivers']
  spec.email         = ['heather@modeanalytics.com']
  spec.summary       = 'Flipper event notifier'
  spec.description   = 'Extensible event notifier for Flipper gem'
  spec.homepage      = 'https://github.com/mode/flipper-echo'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.0'

  spec.add_dependency 'flipper', '0.15'

  spec.add_development_dependency 'bundler',   '~> 1.7'
  spec.add_development_dependency 'rake',      '~> 10.0'
  spec.add_development_dependency 'rspec',     '~> 3.2'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'yard',      '>= 0.9.11'
end
