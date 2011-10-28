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
