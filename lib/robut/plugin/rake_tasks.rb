class Robut::Plugin::RakeTasks
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
