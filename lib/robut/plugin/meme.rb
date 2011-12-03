require 'cgi'
require 'yaml'
require 'yaml/store'

# A simple plugin that wraps memecaptain.
class Robut::Plugin::Meme
  include Robut::Plugin

  def store
    store = YAML::Store.new 'memes.yml'
    store.transaction do
      @memes.each_pair do |name, url|
        store[name] = url
      end
    end
  end

  def reload
    @memes = YAML::load File.open('memes.yml')
  end

  # Returns a description of how to use this plugin
  def usage
    [
      "#{at_nick} meme list - lists all the memes that #{nick} knows about",
      "#{at_nick} meme <meme> <line1>;<line2> - responds with a link to a generated <meme> image using <line1> and <line2>",
      "#{at_nick} meme add <alias> <url> - adds image macro to the meme generator list"
    ]
  end

  # This plugin is activated when robut is sent a message starting
  # with the name of a meme. The list of generators can be discovered
  # by running
  #
  #   @robut meme list
  #
  # from the command line. Example:
  #
  #   @robut meme all_the_things write; all the plugins
  #
  # Send message to the specified meme generator. If the meme requires
  # more than one line of text, lines should be separated with a semicolon.
  def handle(time, sender_nick, message)
    return unless sent_to_me?(message)
    words = words(message)
    command = words.shift.downcase
    return unless command == 'meme'
    meme = words.shift
    reload
    if meme == 'list'
      reply("Memes available: #{@memes.keys.join(', ')}")
    elsif meme.include? 'add'
      words.shift
      @memes[words.first] = words.last
      store
    elsif @memes[meme]
      url = CGI.escape(@memes[meme])
      line1, line2 = words.join(' ').split(';').map { |line| CGI.escape(line.strip)}
      meme_url = "http://memecaptain.com/i?u=#{url}&tt=#{line1}"
      meme_url += "&tb=#{line2}" if line2
      reply(meme_url)
    else
      reply("Meme not found: #{meme}")
    end
  end

end
