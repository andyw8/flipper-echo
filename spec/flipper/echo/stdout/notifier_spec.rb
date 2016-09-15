# encoding: utf-8
#
require 'spec_helper'

describe Flipper::Echo::Stdout::Notifier do
  let :feature do
    double(:feature, name: :experimental)
  end

  let :event do
    Flipper::Echo::Event.new(feature, :enabled)
  end

  let :notifier do
    Flipper::Echo::Stdout::Notifier.new
  end

  describe '#notify' do
    it 'sends message to stdout' do
      expect { notifier.notify(event) }.to output.to_stdout
    end
  end

  describe '#target_message' do
    it 'builds group message' do
      allow(event).to receive(:group).and_return(double(:group, name: :admins))

      expect(notifier.send(:target_message, event)).to eq('group admins')
    end

    it 'builds actor message' do
      allow(event).to(
        receive(:actor).and_return(double(:actor, flipper_id: 'id')))

      expect(notifier.send(:target_message, event)).to eq('actor id')
    end

    it 'builds percentage of actors message' do
      allow(event).to(
        receive(:percentage_of_actors).and_return(double(:actors, value: 15)))

      expect(notifier.send(:target_message, event)).to eq('15% of actors')
    end

    it 'builds percentage of time message' do
      allow(event).to(
        receive(:percentage_of_time).and_return(double(:time, value: 15)))

      expect(notifier.send(:target_message, event)).to eq('15% of time')
    end
  end
end
