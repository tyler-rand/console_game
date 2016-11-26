# a message in the log
class Message
  attr_reader :text, :color

  def initialize(text, color)
    @id = object_id
    @text = text
    @color = color
  end
end
