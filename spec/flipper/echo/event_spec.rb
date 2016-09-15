# encoding: utf-8
#
require 'spec_helper'
require 'flipper'

describe Flipper::Echo::Event do
  let :feature do
    double(:feature)
  end

  let :action do
    double(:action)
  end

  let :group do
    Flipper::Types::Group.new(:dummy)
  end

  let :boolean do
    Flipper::Types::Boolean.new
  end

  let :actor do
    Flipper::Types::Actor.new(double(:actor, flipper_id: nil))
  end

  let :percentage_of_actors do
    Flipper::Types::PercentageOfActors.new(nil)
  end

  let :percentage_of_time do
    Flipper::Types::PercentageOfTime.new(nil)
  end

  describe '#boolean' do
    it 'returns nil if target type does not match' do
      event = Flipper::Echo::Event.new(feature, action, target: group)

      expect(event.boolean).to eq(nil)
    end

    it 'returns target if target type matches' do
      event = Flipper::Echo::Event.new(feature, action, target: boolean)

      expect(event.boolean).to eq(boolean)
    end
  end

  describe '#group' do
    it 'returns nil if target type does not match' do
      event = Flipper::Echo::Event.new(feature, action, target: boolean)

      expect(event.group).to eq(nil)
    end

    it 'returns target if target type matches' do
      event = Flipper::Echo::Event.new(feature, action, target: group)

      expect(event.group).to eq(group)
    end
  end

  describe '#actor' do
    it 'returns nil if target type does not match' do
      event = Flipper::Echo::Event.new(feature, action, target: boolean)

      expect(event.actor).to eq(nil)
    end

    it 'returns target if target type matches' do
      event = Flipper::Echo::Event.new(feature, action, target: actor)

      expect(event.actor).to eq(actor)
    end
  end

  describe '#percentage_of_actors' do
    it 'returns nil if target type does not match' do
      event = Flipper::Echo::Event.new(feature, action, target: boolean)

      expect(event.percentage_of_actors).to eq(nil)
    end

    it 'returns target if target type matches' do
      event = Flipper::Echo::Event.new(
        feature, action, target: percentage_of_actors)

      expect(event.percentage_of_actors).to eq(percentage_of_actors)
    end
  end

  describe '#percentage_of_time' do
    it 'returns nil if target type does not match' do
      event = Flipper::Echo::Event.new(feature, action, target: boolean)

      expect(event.percentage_of_time).to eq(nil)
    end

    it 'returns target if target type matches' do
      event = Flipper::Echo::Event.new(
        feature, action, target: percentage_of_time)

      expect(event.percentage_of_time).to eq(percentage_of_time)
    end
  end

  describe '#gate' do
    it 'returns gate from options' do
      gate = double(:gate)

      event = Flipper::Echo::Event.new(feature, action, gate: gate)

      expect(event.gate).to eq(gate)
    end
  end

  describe '#notify' do
    let :event do
      Flipper::Echo::Event.new(feature, action)
    end

    describe 'when notifier is a proc' do
      it 'calls proc' do
        procedure = proc {}

        allow(event).to receive(:notifiers).and_return([procedure])

        expect(procedure).to receive(:call)

        event.notify
      end
    end

    describe 'when notifier is a non proc object' do
      let :notifier do
        double(:notifier)
      end

      it 'calls instance method if it exists' do
        allow(event).to receive(:notifiers).and_return([notifier])

        expect(notifier).to receive(:notify)

        event.notify
      end

      it 'does nothing if method does not exist' do
        allow(event).to receive(:notifier).and_return(notifier)

        event.notify
      end
    end

    describe 'when notifier is nil' do
      it 'does nothing' do
        allow(event).to receive(:notifier).and_return(nil)

        event.notify
      end
    end
  end

  describe '#notifiers' do
    let :notifier do
      double(:notifier)
    end

    it 'returns notifier from config' do
      allow(Flipper::Echo.configuration).to(
        receive(:notifiers).and_return([notifier]))

      event = Flipper::Echo::Event.new(feature, action)

      expect(event.send(:notifiers)).to eq([notifier])
    end
  end
end
