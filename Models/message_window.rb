require 'curses'

# bottom left window, messages
class MessageWindow
  attr_accessor :win

  def initialize
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

  def display_messages(log)
    win.clear
    print_log(log)
    box_with_title
    win.setpos(8, 6)
    win.refresh
  end

  private

  def print_log(message_log)
    line = 1

    message_log.display_range.each do |line_number|
      message = message_log.log[line_number][0]
      msg_color = message_log.log[line_number][1]

      win.setpos(line, 2)
      win.attron(Curses.color_pair(message_color[msg_color])) { win.addstr(message) }
      line += 1
    end
  end

  def message_color
    {
      'normal' => Curses::A_NORMAL, 'green' => Curses::COLOR_GREEN, 'red' => Curses::COLOR_RED,
      'yellow' => Curses::COLOR_YELLOW
    }
  end
end
