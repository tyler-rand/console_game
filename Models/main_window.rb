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

  def build_map(map)
    display_colored_map(map)
    # seperate into map legend method
    win.setpos(20, 3)
    win.addstr('WASD to move, C to exit')
    win.setpos(22, 3)
    win.addstr('P = Player, m = mob, c = item chest, $ = money chest, x = barrier')
    win.box('|', '-')
    win.setpos(0, 35 - map.name.length / 2)
    win.attron(Curses.color_pair(3)) { win.addstr("Map - #{map.name}") }
  end

  def display_colored_map(map)
    indexed_map = map.current_map.each_with_index.map { |line, i| [line, i] }

    indexed_map.each do |line, i|
      win.setpos(i + 1, 2)
      line_ary = line.split('')

      line_ary.each do |c|
        win.attron(Curses.color_pair(map_colors[c])) { win.addch(c) }
      end
    end
  end

  def box_with_title(title)
    win.box('|', '-')
    win.setpos(0, 29 - title.length / 2)
    win.attron(Curses.color_pair(3)) { win.addstr("ConsoleRPG - #{title}") }
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

  def map_colors
    colors = {
      '.' => Curses::COLOR_GREEN, 'P' => Curses::COLOR_BLUE, '$' => Curses::COLOR_WHITE,
      'x' => Curses::COLOR_RED, 'c' => Curses::COLOR_YELLOW, 'm' => Curses::COLOR_MAGENTA,
      'o' => Curses::A_NORMAL, '_' => Curses::A_NORMAL, 'Q' => Curses::A_NORMAL,
      'W' => Curses::A_NORMAL, 'A' => Curses::A_NORMAL
    }
  end

end
