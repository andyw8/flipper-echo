# encoding: utf-8
#
module Flipper
  module Echo
    module Stdout
      # Simple stdout notifier intended as a basis for more advanced custom
      # notifiers
      #
      class Notifier
        # Send notification message to stdout
        #
        # @return [nil]
        #
        def notify(event)
          parts = []
          parts << '[Flipper]'
          parts << "Feature \"#{event.feature.name}\""
          parts << event.action

          target = target_message(event)

          parts << "for #{target}" if target

          $stdout.puts(parts.join(' '))
        end

        private

        # @return [String, nil]
        #
        def target_message(event)
          if event.group
            "group #{event.group.name}"
          elsif event.actor
            "actor #{event.actor.flipper_id}"
          elsif event.percentage_of_actors
            "#{event.percentage_of_actors.value}% of actors"
          elsif event.percentage_of_time
            "#{event.percentage_of_time.value}% of time"
          end
        end
      end
    end
  end
end
