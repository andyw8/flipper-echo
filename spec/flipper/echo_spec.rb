# encoding: utf-8
#
require 'spec_helper'

describe Flipper::Echo do
  describe '.configure' do
    it 'sets configuration variables' do
      expect_any_instance_of(
        Flipper::Echo::Configuration).to receive(:setting=).once

      Flipper::Echo.configure do |config|
        config.setting = 'value'
      end
    end
  end

  describe '.configuration' do
    it 'is a configuration instance' do
      expect(Flipper::Echo.configuration).to(
        be_an_instance_of(Flipper::Echo::Configuration))
    end
  end

  describe Flipper::Echo::InstanceMethods do
    let :adapter do
      adapter_class.new.tap do |inst|
        inst.singleton_class.include Flipper::Echo::InstanceMethods
      end
    end

    let :feature do
      double(:feature)
    end

    let :gate do
      double(:gate)
    end

    let :target do
      double(:target)
    end

    describe '#enable' do
      it 'enables feature' do
        expect_any_instance_of(Flipper::Echo::Event).to receive(:notify) do |e|
          expect(e.action).to eq(:enabled)
        end

        adapter.enable(feature, gate, target)
      end
    end

    describe '#disable' do
      it 'disables feature' do
        expect_any_instance_of(Flipper::Echo::Event).to receive(:notify) do |e|
          expect(e.action).to eq(:disabled)
        end

        adapter.disable(feature, gate, target)
      end
    end

    describe '#remove' do
      it 'removes feature' do
        expect_any_instance_of(Flipper::Echo::Event).to receive(:notify) do |e|
          expect(e.action).to eq(:removed)
        end

        adapter.remove(feature)
      end
    end

    describe '#clear' do
      it 'clears feature' do
        expect_any_instance_of(Flipper::Echo::Event).to receive(:notify) do |e|
          expect(e.action).to eq(:cleared)
        end

        adapter.clear(feature)
      end
    end
  end
end
