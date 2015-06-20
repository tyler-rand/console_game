# a game's message log
class MessageLog
  attr_accessor :id, :game, :log, :display_range

  #
  ## INSTANCE METHODS
  #

  def initialize(game:)
    @id   = object_id
    @game = game
    @log  = []
    @display_range = -8..-1
  end

  def scroll(num)
    self.display_range = self.display_range.map { |x| x += num }
  end

end
