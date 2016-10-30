# a message in the log
class Message
  attr_accessor :id, :text, :color

  def initialize(text, color)
    @id = object_id
    @text = text
    @color = color
  end
end
