# encoding: utf-8
#
require 'spec_helper'

describe Flipper::Echo::Slack::Notifier do
  describe '#channel' do
    it 'is null if options do not include channel' do
      notifier = Flipper::Echo::Slack::Notifier.new('https://hook')

      expect(notifier.channel).to eq(nil)
    end

    it 'returns channel from options without prepending' do
      notifier = Flipper::Echo::Slack::Notifier.new(
        'https://hook', channel: '#custom_channel')

      expect(notifier.channel).to eq('#custom_channel')
    end

    it 'returns channel from options with prepending' do
      notifier = Flipper::Echo::Slack::Notifier.new(
        'https://hook', channel: 'custom_channel')

      expect(notifier.channel).to eq('#custom_channel')
    end
  end

  describe '#username' do
    it 'is default if options do not include username' do
      notifier = Flipper::Echo::Slack::Notifier.new('https://hook')

      expect(notifier.username).to eq('Flipper')
    end

    it 'returns username from options' do
      notifier = Flipper::Echo::Slack::Notifier.new(
        'https://hook', username: 'Custom Username')

      expect(notifier.username).to eq('Custom Username')
    end
  end

  describe '#icon_url' do
    it 'is default if options do not include url' do
      notifier = Flipper::Echo::Slack::Notifier.new('https://hook')

      expect(notifier.icon_url).to match(/flipper\-echo\-icon/)
    end

    it 'returns username from options' do
      notifier = Flipper::Echo::Slack::Notifier.new(
        'https://hook', icon_url: 'custom-icon')

      expect(notifier.icon_url).to eq('custom-icon')
    end
  end

  describe '#notify' do
    let :feature do
      double(:feature, name: :experimental)
    end

    let :event do
      Flipper::Echo::Event.new(feature, :action)
    end

    it 'calls notifier with expected options' do
      notifier = Flipper::Echo::Slack::Notifier.new('https://hook')

      expect(notifier).to receive(:post) do |options|
        expect(options[:text]).to match(/experimental/)
      end

      notifier.notify(event)
    end
  end

  describe '#post' do
    it 'posts expected json payload' do
      notifier = Flipper::Echo::Slack::Notifier.new('https://hook')

      expect(notifier.send(:http)).to receive(:request) do |request|
        expect(request.body).to eq('{"foo":"bar"}')
        expect(request.content_type).to eq('application/json')

        double(:response, code: '200')
      end

      notifier.send(:post, foo: 'bar')
    end

    it 'prints unexpected api response to stderr' do
      notifier = Flipper::Echo::Slack::Notifier.new('https://hook')

      expect(notifier.send(:http)).to(
        receive(:request).and_return(double(:response, code: '404')))

      expect { notifier.send(:post, foo: 'bar') }.to output.to_stderr
    end
  end

  describe '.normalize_channel' do
    it 'is nil for blank name' do
      expect(Flipper::Echo::Slack::Notifier.normalize_channel(nil)).to eq(nil)
      expect(Flipper::Echo::Slack::Notifier.normalize_channel('')).to eq(nil)
    end

    it 'preserves name including number sign' do
      result = Flipper::Echo::Slack::Notifier.normalize_channel('#channel_name')

      expect(result).to eq('#channel_name')
    end

    it 'prepends number sign if necessary' do
      result = Flipper::Echo::Slack::Notifier.normalize_channel('channel_name')

      expect(result).to eq('#channel_name')
    end

    it 'preserves at sign' do
      result = Flipper::Echo::Slack::Notifier.normalize_channel('@channel_name')

      expect(result).to eq('@channel_name')
    end
  end
end
