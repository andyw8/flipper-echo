# encoding: utf-8
#
module Flipper
  module Echo
    module Slack
      # Slack message formatter
      #
      class Message
        attr_reader :event

        # Construct a new Message instance
        #
        # @param event [Flipper::Echo::Event] the Flipper event
        #
        # @return [Flipper::Echo::Slack::Message] the instance
        #
        def initialize(event)
          @event = event
        end

        # Build message body
        #
        # @return [String] the message body
        #
        def to_s
          [base, event.action, filters].compact.join(' ')
        end

        private

        # @return [String]
        #
        def base
          parts = []
          parts << "[*#{environment}*]" if environment
          parts << "Feature `#{event.feature.name}`"
          parts.join(' ')
        end

        # @return [String, nil]
        #
        def filters
          if event.group
            "for group `#{event.group.name}`"
          elsif event.actor
            "for actor `#{event.actor.flipper_id}`"
          elsif event.percentage_of_actors
            "for #{event.percentage_of_actors.value}% of actors"
          elsif event.percentage_of_time
            "for #{event.percentage_of_time.value}% of time"
          end
        end

        # @return [String, nil]
        #
        def environment
          Flipper::Echo.configuration.environment
        end
      end
    end
  end
end
