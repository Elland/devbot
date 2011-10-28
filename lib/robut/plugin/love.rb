class Love
  include Robut::Plugin

  def usage
    "#{at_nick} love - will love you"
  end

  def handle(time, sender_nick, message)
     return unless sent_to_me?(message); words = words(message); command = words.shift.downcase; return unless command == 'love'; reply("@#{sender_nick.split.first} I love you man!!");
  end
end
Robut::Plugin.plugins -= [Love] if Robut::Plugin.plugins.include? Love
Robut::Plugin.plugins << Love
