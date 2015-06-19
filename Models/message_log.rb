# a game's message log
class MessageLog
  attr_accessor :id, :game, :log

  #
  ## INSTANCE METHODS
  #

  def initialize(game)
  	@id   = object_id
    @game = game
    @log  = []
  end
end
