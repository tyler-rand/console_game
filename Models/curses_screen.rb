require 'curses'

# curses screen class that initializes the three visible windows
class CursesScreen
  def initialize
    Curses.init_screen
    Curses.crmode
    Curses.start_color
    Curses.init_pair(Curses::COLOR_GREEN, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
    Curses.init_pair(Curses::COLOR_WHITE, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
    Curses.init_pair(Curses::COLOR_YELLOW, Curses::COLOR_YELLOW, Curses::COLOR_BLACK)
    Curses.init_pair(Curses::COLOR_BLUE, Curses::COLOR_WHITE, Curses::COLOR_BLUE)
    Curses.init_pair(Curses::COLOR_RED, Curses::COLOR_RED, Curses::COLOR_BLACK)
    Curses.init_pair(Curses::COLOR_MAGENTA, Curses::COLOR_WHITE, Curses::COLOR_RED)
  end

  def build_display
    main_win = MainWindow.new
    message_log = MessageLog.new
    message_win = MessageWindow.new(message_log)
    right_win = RightWindow.new

    main_win.win.box('|', '-')
    main_win.win.setpos(20, 3)

    return main_win, message_win, right_win
  end
end
