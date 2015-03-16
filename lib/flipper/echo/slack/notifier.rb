# encoding: utf-8
#
require 'json'
require 'net/https'
require 'uri'

module Flipper
  module Echo
    module Slack
      # Customizable Slack webhook notifier
      #
      class Notifier
        attr_reader :webhook_url, :options

        # Construct a new Notifier instance
        #
        # @param webhook_url [String] the Slack webhook url
        # @param options [optional, Hash] hash of options
        #
        # @option options [String] :username Slack bot username
        # @option options [String] :channel name of Slack channel
        # @option options [String] :icon_url the message icon url
        #
        # @return [Flipper::Echo::Slack::Notifier] the instance
        #
        def initialize(webhook_url, options = {})
          @webhook_url = webhook_url
          @options     = self.class.symbolize_keys(options)
        end

        # Normalized channel name
        #
        # @return [String, nil]
        #
        def channel
          @channel ||= self.class.normalize_channel(options[:channel])
        end

        # Slack message username
        #
        # @return [String, nil]
        #
        def username
          options.fetch(:username, DEFAULT_USERNAME)
        end

        # Slack message icon url
        #
        # @return [String, nil]
        #
        def icon_url
          options.fetch(:icon_url, DEFAULT_ICON_URL)
        end

        # Post notification to Slack webhook url
        #
        # @return [HTTPResponse]
        #
        def notify(event)
          message = Flipper::Echo::Slack::Message.new(event)

          payload = {
            text:     message.to_s,
            channel:  channel,
            username: username,
            icon_url: icon_url
          }

          post(payload)
        end

        class << self
          # Normalize Slack channel name for API
          #
          # @param name [String] the original name
          #
          # @return [String] the normalized name
          #
          def normalize_channel(name)
            return unless name && name.size > 0

            name =~ /\A[#@]/ ? name : "##{name}"
          end

          # Symbolize hash keys
          #
          # @param hash [Hash] the original hash
          #
          # @return [Hash] hash with symbolized keys
          #
          def symbolize_keys(hash)
            hash.each_with_object({}) do |(key, value), result|
              result[key.to_sym] = value
            end
          end
        end

        private

        DEFAULT_USERNAME = 'Flipper'

        DEFAULT_ICON_URL =
          'https://s3-us-west-2.amazonaws.com/mode.production/' \
          'flipper-echo/flipper-echo-icon-132.png'

        # @return [Net::HTTP]
        #
        def http
          @http ||= Net::HTTP.new(uri.host, uri.port).tap do |result|
            result.use_ssl = ssl?
          end
        end

        # @return [URI]
        #
        def uri
          @uri ||= URI.parse(webhook_url)
        end

        # @return [true, false]
        #
        def ssl?
          uri.scheme == 'https'
        end

        # @return [HTTPResponse]
        #
        def post(payload)
          request = Net::HTTP::Post.new(uri.request_uri)
          request.set_content_type('application/json')
          request.body = payload.to_json

          http.request(request).tap do |response|
            unless response.code == '200'
              $stderr.puts 'Unexpected Slack notifier response: ' \
                           "#{response.code}"
            end
          end
        end
      end
    end
  end
end
