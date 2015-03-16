# encoding: utf-8
#
require 'flipper/echo/configuration'
require 'flipper/echo/event'
require 'flipper/echo/slack'
require 'flipper/echo/stdout'
require 'flipper/echo/version'

# Flipper namespace
#
module Flipper
  # Echo namespace
  #
  module Echo
    class << self
      # Yield configuration instance for modification
      #
      def configure
        yield configuration if block_given?
      end

      # Configuration instance
      #
      def configuration
        @configuration ||= Flipper::Echo::Configuration.new
      end
    end

    # Instance methods to be included in the adapter's singleton class
    #
    module InstanceMethods
      # Notify adapter enable events
      #
      def enable(feature, gate, target)
        super.tap do
          Flipper::Echo::Event.new(
            feature, :enabled, gate: gate, target: target).notify
        end
      end

      # Notify adapter disable events
      #
      def disable(feature, gate, target)
        super.tap do
          Flipper::Echo::Event.new(
            feature, :disabled, gate: gate, target: target).notify
        end
      end

      # Notify adapter remove events
      #
      def remove(feature)
        super.tap { Flipper::Echo::Event.new(feature, :removed).notify }
      end

      # Notify adapter clear events
      #
      def clear(feature)
        super.tap { Flipper::Echo::Event.new(feature, :cleared).notify }
      end
    end
  end
end
