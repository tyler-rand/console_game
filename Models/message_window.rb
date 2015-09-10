require 'curses'

# bottom left window, messages
class MessageWindow
  attr_accessor :win, :message_log

  def initialize
    @message_log = MessageLog.new
    @win = Curses::Window.new(10, 70, 26, 0)
    box_with_title
    @win.refresh
  end

  def box_with_title
    win.box('|', '-')
    win.setpos(0, 28)
    win.attron(Curses.color_pair(3)) { win.addstr('Input/Message Log') }
    win.setpos(1, 2)
  end

  def display_messages(messages)
    message_log.add_msgs(messages)

    win.clear
    print_log
    box_with_title
    win.setpos(8, 6)
    win.refresh
  end

  private

  def print_log
    window_line = 1

    message_log.display_range.each do |line|
      win.setpos(window_line, 2)
      win.attron(Curses.color_pair(message_color[color(line)])) { win.addstr(msg(line)) }
      window_line += 1
    end
  end

  def message_color
    {
      'normal' => Curses::A_NORMAL, 'green' => Curses::COLOR_GREEN, 'red' => Curses::COLOR_RED,
      'yellow' => Curses::COLOR_YELLOW
    }
  end

  def msg(line)
    message_log.log[line][0]
  end

  def color(line)
    message_log.log[line][1]
  end
end
