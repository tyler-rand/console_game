# a game's message log
class MessageLog
  attr_accessor :id, :log, :display_range

  MAX_MSG_LENGTH = 67

  def initialize
    @id = object_id
    @log = [['> ', 'yellow', 0], ['> ', 'yellow', 1], ['> ', 'yellow', 2], ['> ', 'yellow', 3],
            ['> ', 'yellow', 4], ['> ', 'yellow', 5], ['> ', 'yellow', 6]]
    @display_range = -1..6
  end

  def add_msgs(messages)
    # so messages can be array or single message
    messages = [messages].flatten
    scroll_amount = messages.length

    messages.each { |msg| scroll_amount += add_to_log(msg) }
    scroll(scroll_amount)
  end

  # appends input to last line already displayed
  def append(input)
    input = '' unless input.is_a?(String)

    log[-1][0] += input
  end

  private

  def add_to_log(msg)
    scroll_amount = 0

    while msg.text.length > MAX_MSG_LENGTH
      split_messages(msg)
      scroll_amount += 1
    end

    log << [msg.text, msg.color, log.length]

    scroll_amount
  end

  def split_messages(msg)
    msg_sliced = formatted_line(msg.text)
    log << [msg_sliced, msg.color, log.length]
  end

  def formatted_line(msg)
    msg_sliced = msg.slice(0, MAX_MSG_LENGTH).rpartition(' ')[0] + ' '

    msg.slice!(0, msg_sliced.length)
  end

  def scroll(num)
    self.display_range = display_range.map { |x| x + num }
  end
end
