# a game's message log
class MessageLog
  attr_accessor :id, :game, :log, :display_range

  #
  ## INSTANCE METHODS
  #

  def initialize(game:)
    @id   = object_id
    @game = game
    @log  = [['', 0], ['', 1], ['', 2], ['', 3], ['', 4], ['', 5], ['', 6]]
    @display_range = -1..6
  end

  def add_msgs(messages)
    messages.each { |m| self.log << [m, log.length] }
    scroll(messages.length)
  end

  def scroll(num)
    self.display_range = self.display_range.map { |x| x += num }
  end

end
