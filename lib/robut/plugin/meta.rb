class Robut::Plugin::MetaPlugin
  include Robut::Plugin

  def usage
    "#{at_nick} meta <plugin_name>, <usage_description>, <handler code> - injects a plugin that does <handler_code> according to <usage>"
  end

  def handle(time, sender_nick, message)
    return unless sent_to_me?(message)
    words = words(message)
    command = words.shift.downcase
    return unless command == 'meta'
    /\<(.+)\>, \<(.+)\>, \<(.+)\>/.match(words.join(' '))
    plugin_name, usage, code = $1, $2, $3
    add_plugin plugin_name, usage, code
    Robut::Plugin.plugins -= eval("[Robut::Plugin::#{plugin.capitalize}]") if Robut::Plugin.plugins.include? eval("Robut::Plugin::#{plugin.capitalize}")
    Robut::Plugin.plugins << eval("Robut::Plugin::#{plugin.capitalize}")
  end

  def add_plugin plugin, usage, code
    plugincode = <<EOF
    class Robut::Plugin::#{plugin.capitalize}
      include Robut::Plugin

      def usage
        "#{usage}"
      end

      def handle(time, sender_nick, message)
        #{code}
      end
    end
EOF
  File.open("lib/robut/plugin/#{plugin.downcase}.rb", "w") { |f| f.write(plugincode) }
  eval plugincode
  #File.open("Chatfile", "w") {|f| a= f.read; f.write("require \"robut/plugin/#{plugin.downcase}\" \n #{a}") }
  end
end
