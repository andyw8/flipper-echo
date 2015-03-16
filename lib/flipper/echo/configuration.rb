# encoding: utf-8
#
module Flipper
  module Echo
    # General configuration class
    #
    # If `notifier` is not assigned, notification events will not be sent.
    #
    # Only one of `#flipper=` or `#adapter=`, as preferred, must be called for
    # intended behavior.
    #
    class Configuration
      # All configured notifiers
      #
      # @return [Array]
      #
      def notifiers
        @notifiers ||= []
      end

      # Convenience method for assigning a single notifier
      #
      # @return [Array] all notifiers
      #
      def notifier=(notifier)
        notifiers << notifier
      end

      # Optional environment name
      #
      attr_writer :environment

      # Configured environment name
      #
      # @return [String]
      #
      def environment
        @environment ||= ENV['FLIPPER_ECHO_ENVIRONMENT']
      end

      # Assign Flipper instance
      #
      # @param flipper [Flipper::DSL] the Flipper instance
      #
      # @return [Class] the adapter singleton class
      #
      def flipper=(flipper)
        self.adapter = flipper.adapter
      end

      # Assign Flipper adapter instance
      #
      # @param adapter [Flipper::Adapter] the Flipper adapter instance
      #
      # @return [Class] the adapter singleton class
      #
      def adapter=(adapter)
        adapter.singleton_class.send :include, Flipper::Echo::InstanceMethods
      end
    end
  end
end
