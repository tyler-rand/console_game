# a game's message log
class MessageLog
  attr_accessor :id, :log, :display_range

  #
  ## INSTANCE METHODS
  #

  def initialize
    @id = object_id
    @log = [['> ', 'yellow', 0], ['> ', 'yellow', 1], ['> ', 'yellow', 2], ['> ', 'yellow', 3],
            ['> ', 'yellow', 4], ['> ', 'yellow', 5], ['> ', 'yellow', 6]]
    @display_range = -1..6
  end

  def add_msgs(messages) # expects array
    messages.each { |msg| log << [msg.text, msg.color, log.length] }
    scroll(messages.length)
  end

  def append(input) # appends input to last line already displayed
    log[-1][0] += input
  end

  private

  def scroll(num)
    self.display_range = display_range.map { |x| x + num }
  end
end
