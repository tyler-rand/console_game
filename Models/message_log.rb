# a game's message log
class MessageLog
  attr_accessor :id, :log, :display_range

  #
  ## INSTANCE METHODS
  #

  def initialize
    @id   = object_id
    @log  = [['', 'normal', 0], ['', 'normal', 1], ['', 'normal', 2], ['', 'normal', 3],
             ['', 'normal', 4], ['', 'normal', 5], ['', 'normal', 6]]
    @display_range = -1..6
  end

  def add_msgs(messages)
    messages.each { |msg, color| self.log << [msg, color, log.length] }
    scroll(messages.length)
  end

  def scroll(num)
    self.display_range = self.display_range.map { |x| x += num }
  end
end
