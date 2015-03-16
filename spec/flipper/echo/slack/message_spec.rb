# encoding: utf-8
#
require 'spec_helper'

describe Flipper::Echo::Slack::Message do
  let :feature do
    double(:feature, name: :experimental)
  end

  describe '#base' do
    let :event do
      Flipper::Echo::Event.new(feature, :enabled)
    end

    it 'builds expected string without environment' do
      message = Flipper::Echo::Slack::Message.new(event)

      expect(message.send(:base)).to eq('Feature `experimental`')
    end

    it 'builds expected string with environment' do
      message = Flipper::Echo::Slack::Message.new(event)

      allow(message).to receive(:environment).and_return('staging')

      expect(message.send(:base)).to eq('[*staging*] Feature `experimental`')
    end
  end

  describe '#filters' do
    it 'builds group string' do
      event   = Flipper::Echo::Event.new(feature, :disabled)
      message = Flipper::Echo::Slack::Message.new(event)

      group = double(:group, name: 'admins')
      allow(event).to receive(:group).and_return(group)

      expect(message.send(:filters)).to eq('for group `admins`')
    end

    it 'builds actor string' do
      event   = Flipper::Echo::Event.new(feature, :disabled)
      message = Flipper::Echo::Slack::Message.new(event)

      actor = double(:actor, flipper_id: 'Actor:1')
      allow(event).to receive(:actor).and_return(actor)

      expect(message.send(:filters)).to eq('for actor `Actor:1`')
    end

    it 'builds percentage of actors string' do
      event   = Flipper::Echo::Event.new(feature, :disabled)
      message = Flipper::Echo::Slack::Message.new(event)

      percentage = double(:percentage, value: '10')
      allow(event).to receive(:percentage_of_actors).and_return(percentage)

      expect(message.send(:filters)).to eq('for 10% of actors')
    end

    it 'builds percentage of random string' do
      event   = Flipper::Echo::Event.new(feature, :disabled)
      message = Flipper::Echo::Slack::Message.new(event)

      percentage = double(:percentage, value: '10')
      allow(event).to receive(:percentage_of_random).and_return(percentage)

      expect(message.send(:filters)).to eq('for 10% of random')
    end
  end

  describe '#environment' do
    it 'returns configured environment' do
      allow(Flipper::Echo.configuration).to(
        receive(:environment).and_return('staging'))

      message = Flipper::Echo::Slack::Message.new(nil)

      expect(message.send(:environment)).to eq('staging')
    end
  end
end
