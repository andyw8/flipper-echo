# encoding: utf-8
#
require 'spec_helper'

describe Flipper::Echo::Configuration do
  let :adapter do
    adapter_class.new
  end

  let :flipper do
    double(:flipper, adapter: adapter)
  end

  let :configuration do
    Flipper::Echo::Configuration.new
  end

  describe '#adapter=' do
    it 'assigns adapter' do
      expect(adapter.singleton_class).to receive(:include)

      configuration.adapter = adapter
    end
  end

  describe '#flipper=' do
    it 'assigns adapter' do
      expect(adapter.singleton_class).to receive(:include)

      configuration.flipper = flipper
    end
  end

  describe '#notifier=' do
    it 'appends notifier' do
      notifier = double(:notifier)

      expect(configuration.notifiers).to eq([])

      configuration.notifier = notifier

      expect(configuration.notifiers).to eq([notifier])
    end
  end
end
