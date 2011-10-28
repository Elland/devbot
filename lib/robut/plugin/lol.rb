    class Lol
      include Robut::Plugin

      def usage
        "#{at_nick} lol - will lol @ you"
      end

      def handle(time, sender_nick, message)
         return unless sent_to_me?(message); words = words(message); command = words.shift.downcase; return unless command == 'lol'; reply("@#{sender_nick} lol dude");
      end
    end
