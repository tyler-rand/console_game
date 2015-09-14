require 'curses'

# main, top-left window
class MainWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(26, 70, 0, 0)
    @win.refresh
  end

  def refresh_display(title:)
    win.clear
    yield if block_given?
    box_with_title(title)
    win.refresh
  end

  def build_map(map_display)
    map_display.display_colored_map

    win.setpos(20, 3)
    win.addstr('WASD to move, C to exit')
    win.setpos(22, 3)
    win.addstr('P = Player, m = mob, c = item chest, $ = money chest, x = barrier')

    box_with_title("Map: #{map_display.map.name}")
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

  def box_with_title(title)
    win.box('|', '-')
    win.setpos(0, 29 - title.length / 2)
    win.attron(Curses.color_pair(3)) { win.addstr("ConsoleRPG - #{title}") }
  end
end
