# curses related classes
require 'curses'

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
    @main_win = MainWindow.new
    @messages_win = MessagesWindow.new
    @right_win = RightWindow.new

    @main_win.win.box('j', '~')
    @main_win.win.setpos(20, 3)

    return @main_win, @messages_win, @right_win
  end
end

class MainWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(26, 70, 0, 0)
    @win.refresh
  end

  def build_map(map)
    win.setpos(20, 3)
    win.addstr('WASD to move, C to exit')
    win.setpos(22, 3)
    win.addstr('P = Player, m = mob, c = item chest, $ = money chest, x = barrier')

    indexed_map = map.current_map.each_with_index.map{ |line,i| [line, i] }

    indexed_map.each do |line, i|
      win.setpos(i + 1, 2)
      line_ary = line.split('')

      line_ary.each do |c|
        win.attron(Curses.color_pair(map_colors_hash(c))) { win.addch(c) }
      end
    end

    win.box('j', '~')
    win.setpos(0, 35-map.name.length/2)
    win.addstr("Map - #{map.name}")
  end

end

class MessagesWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(7, 70, 26, 0)
    @win.box('j', '~')
    @win.setpos(0, 28)
    @win.addstr('Input/Message Log')
    @win.setpos(1, 2)
    @win.refresh
  end
end

class RightWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(33, 30, 0, 70)
    @win.box('j', '~')
    @win.setpos(0, 8)
    @win.addstr('Stats/Equipped')
    @win.setpos(1, 2)
    @win.refresh
  end
end