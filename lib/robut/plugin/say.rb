    class Say
      include Robut::Plugin

      def usage
        "#{at_nick} say <args> - will say args using mac os x say shell command"
      end

      def handle(time, sender_nick, message)
         return unless sent_to_me?(message); words = words(message); command = words.shift.downcase; return unless command == 'say'; `say -v "Good News" #{words.join(' ')}`;
      end
    end
    Robut::Plugin.plugins -= [Say] if Robut::Plugin.plugins.include? Say
    Robut::Plugin.plugins << Say
