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
      attr_accessor :notifier

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
        adapter.singleton_class.include Flipper::Echo::InstanceMethods
      end
    end
  end
end
