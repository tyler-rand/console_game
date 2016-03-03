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
    scroll_amount = messages.length

    messages.each do |msg|
      msg_max_length = 67
      scroll_amount = split_messages(msg, msg_max_length, scroll_amount) while msg.text.length > msg_max_length
      log << [msg.text, msg.color, log.length]
    end

    scroll(scroll_amount)
  end

  def append(input) # appends input to last line already displayed
    log[-1][0] += input
  end

  private

  def scroll(num)
    self.display_range = display_range.map { |x| x + num }
  end

  def split_messages(msg, msg_max_length, scroll_amount)
    msg_sliced = formatted_line(msg.text, msg_max_length)
    log << [msg_sliced, msg.color, log.length]
    scroll_amount += 1
  end

  def formatted_line(msg, msg_max_length)
    msg_sliced = msg.slice(0, msg_max_length).rpartition(' ')[0] + ' '

    msg_sliced_formatted = msg.slice!(0, msg_sliced.length)
  end
end
