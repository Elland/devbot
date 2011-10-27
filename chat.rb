# Require your plugins here
require 'robut/plugin'
require 'robut/plugin/twss'
require 'robut/storage/yaml_store'
require 'robut/plugin/echo'
require 'robut/plugin/meme'
require 'robut/plugin/alias'
require 'robut/plugin/help'
require 'robut/plugin/later'
require 'robut/plugin/ping'
require 'robut/plugin/sayings'



# Add the plugin classes to the Robut plugin list.
# Plugins are handled in the order that they appear in this array.
class RakeTasks
  include Robut::Plugin

  def usage
    "#{at_nick} rake <task> - if <task> matches a rake task, it will execute it and reply the output"
  end

  def handle(time, sender_nick, message)
    return unless sent_to_me?(message)
    words = words(message)
    command = words.shift.downcase
    return unless command == 'rake'
    task = words.shift
    output = IO.popen("rake #{task} 2>&1").readlines
    reply("#{output.join}", sender_nick)
  end
end

class ShellInterface
  include Robut::Plugin

  def usage
    "#{at_nick} sh <shellcmd> - will execute shellcmd as is, without root privileges, directly on the server ** be careful **"
  end

  def handle(time, sender_nick, message)
    @whitelist = ['ls', 'pwd']
    return unless sent_to_me?(message)
    words = words(message)
    command = words.shift.downcase
    return unless command == 'sh'
    shellcmd = words.shift
    if @whitelist.include? shellcmd.split(' ').first
      output = IO.popen("#{shellcmd}").readlines
      reply("#{output.join}", sender_nick)
    else
      reply("Hey, @#{sender_nick}, this command is blacklisted!")
    end
  end
end

class MetaPlugin
  def add_plugin plugin, usage, code
    plugincode = <<EOF
    class #{plugin.capitalize}
      include Robut::Plugin

      def usage
        #{usage}
      end

      def handle(time, sender_nick, message)
        #{code}
      end
    end
    Robut::Plugin.plugins << #{plugin.capitalize}
EOF
  File.new("#{plugin.downcase}.rb", "w") { |f| f.write(plugincode) }
  end

  def usage
    "#{at_nick} meta <plugin_name>, <usage_description>, <handler code> - injects a plugin that does <handler_code> according to <usage>"
  end

  def handle(time, sender_nick, message)
    return unless set_to_me?(message)
    words = words(message)
    command = words.shift.downcase
    return unless command == 'meta'
    /\<(.+)\>, \<(.+)\>, \<(.+)\>/.match(command)
    plugin_name, usage, code = $1, $2, $3
    add_plugin plugin_name, usage, code
  end

end

Robut::Plugin.plugins << RakeTasks
#Robut::Plugin.plugins << ShellInterface

Robut::Plugin.plugins << Robut::Plugin::Alias
Robut::Plugin.plugins << Robut::Plugin::Sayings
#Robut::Plugin.plugins << Robut::Plugin::TWSS
Robut::Plugin.plugins << Robut::Plugin::Echo
Robut::Plugin.plugins << Robut::Plugin::Later
Robut::Plugin.plugins << Robut::Plugin::Meme
Robut::Plugin.plugins << Robut::Plugin::Help
Robut::Plugin.plugins << MetaPlugin

Robut::Plugin::Sayings.sayings = [["hey", "hey there!"], ["you're the worst", "I know."], ["sucks", "You know something, you suck!" ]]

# Configure the robut jabber connection and you're good to go!
Robut::Connection.configure do |config|
  config.jid = '14230_50799@chat.hipchat.com'
  config.password = 'passwordbot'
  config.nick = 'Dev Bot'
  config.room = '14230_bot_test@conf.hipchat.com'
#  config.room = '14230_everything_goes@conf.hipchat.com'

  # Some plugins require storage
  Robut::Storage::YamlStore.file = ".robut"
  config.store = Robut::Storage::YamlStore

  # Add a logger if you want to debug the connection
  # config.logger = Logger.new(STDOUT)
end
