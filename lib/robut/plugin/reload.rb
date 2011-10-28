class Robut::Plugin::FileReload
  include Robut::Plugin

  def usage
    "#{at_nick} reload - reloads all plugin files"
  end

  def handle(time, sender_nick, message)
    return unless sent_to_me?(message)
    words = words(message)
    command = words.shift.downcase
    return unless command == 'reload'
    reply("Atempting to load files!")
    Dir["./lib/robut/plugin/*.rb"].each do |file|
      load file
      reply("Loaded #{file.split('/').last.split('.').first}!")
    end
  end
end
