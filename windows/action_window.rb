require 'curses'

# displays different menus requiring input, ex. mob battle, map list, player/vendor inventory, etc
class ActionWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(26, 40, 0, 0)
    box_with_title
    @win.refresh
  end

  def refresh_display
    win.clear
    yield if block_given?
    box_with_title
    win.refresh
  end

  def getch_no_echo
    Curses.noecho
    Curses.curs_set(0)
    win.setpos(24, 2)
    input = win.getch
    Curses.curs_set(1)
    Curses.echo

    input
  end

  private

  def box_with_title
    win.box('|', '-')
    win.setpos(0, 14)
    win.attron(Curses.color_pair(3)) { win.addstr(' ConsoleRPG ') }
  end
end
