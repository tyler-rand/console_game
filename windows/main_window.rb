require 'curses'

# main, top-left window
class MainWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(26, 30, 0, 40)
    @win.refresh
  end

  def refresh_display(title:)
    win.clear
    yield if block_given?
    box_with_title(title)
    win.refresh
  end

  def build_map(map_display)
    win.clear
    map_display.display_colored_map
    display_controls
    box_with_title("Map: #{map_display.map.name}")
  end

  def get_char_without_echo
    input = curses_get_char_without_echo
    if input.class < Integer
      'm' # set to unused char, FIXME: this is dumb
    else
      input.downcase
    end
  end

  private

  def curses_get_char_without_echo
    Curses.noecho
    Curses.curs_set(0)
    win.setpos(24, 2)
    win.getch.tap do
      Curses.curs_set(1)
      Curses.echo
    end
  end

  def box_with_title(title)
    win.box('|', '-')
    title_indent = (13 - (title.length / 2)).floor
    win.setpos(0, title_indent)
    win.attron(Curses.color_pair(3)) { win.addstr(" #{title} ") }
  end

  def display_controls
    win.setpos(22, 3)
    win.attron(Curses.color_pair(2)) { win.addstr('WASD') }
    win.addstr(' to move, ')
    win.attron(Curses.color_pair(1)) { win.addstr('C') }
    win.addstr(' to exit.')
    win.setpos(23, 3)
    win.attron(Curses.color_pair(3)) { win.addstr('B') }
    win.addstr(' bag, ')
    win.attron(Curses.color_pair(3)) { win.addstr('L') }
    win.addstr(' map legend')
    win.setpos(24, 3)
    win.attron(Curses.color_pair(3)) { win.addstr('E') }
    win.addstr(' equipped, ')
    win.attron(Curses.color_pair(3)) { win.addstr('Q') }
    win.addstr(' quest log')
  end
end
