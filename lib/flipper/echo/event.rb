# encoding: utf-8
#
module Flipper
  module Echo
    # Encapsulates relevant information about a Flipper adapter event
    #
    class Event
      attr_reader :feature, :action, :options

      # Construct a new Event instance
      #
      # @param feature [Flipper::Feature] the feature that was changed
      # @param action [Symbol] the action
      #   (`:enable`, `:disable`, `:remove` or `:clear`)
      # @param options [optional, Hash] hash of options
      #
      # @option options [Flipper::Type] :target the event target
      # @option options [Flipper::Gate] :gate the event gate
      #
      # @return [Flipper::Echo::Event] the instance
      #
      def initialize(feature, action, options = {})
        @feature = feature
        @action  = action
        @options = options
      end

      # Boolean target
      #
      # @return [Flipper::Types::Boolean, nil]
      #
      def boolean
        target if target.is_a?(Flipper::Types::Boolean)
      end

      # Group target
      #
      # @return [Flipper::Types::Group, nil]
      #
      def group
        target if target.is_a?(Flipper::Types::Group)
      end

      # Actor target
      #
      # @return [Flipper::Types::Actor, nil]
      #
      def actor
        target if target.is_a?(Flipper::Types::Actor)
      end

      # Percentage of actors target
      #
      # @return [Flipper::Types::PercentageOfActors, nil]
      #
      def percentage_of_actors
        target if target.is_a?(Flipper::Types::PercentageOfActors)
      end

      # Percentage of random target
      #
      # @return [Flipper::Types::PercentageOfRandom, nil]
      #
      def percentage_of_random
        target if target.is_a?(Flipper::Types::PercentageOfRandom)
      end

      # Passes this event to the configured notifier
      #
      def notify
        if notifier.is_a?(Proc)
          notifier.call(self)
        elsif notifier.respond_to?(:notify)
          notifier.notify(self)
        end
      end

      # The event target, if any
      #
      # @return [Flipper::Type]
      #
      def target
        options[:target]
      end

      # The event gate, if any
      #
      # @return [Flipper::Gate]
      #
      def gate
        options[:gate]
      end

      private

      def notifier
        Flipper::Echo.configuration.notifier
      end
    end
  end
end
