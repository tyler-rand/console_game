# curses related classes
require 'curses'

class CursesScreen

  def initialize
    Curses.noecho
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

  def build_display(map)
    @map_win = MapWindow.new(map)
    @messages_win = MessagesWindow.new
    @right_win = RightWindow.new

    map_with_index = map.current_map.each_with_index.map{ |line,i| [line, i] }

    map_with_index.each do |line, i|
      @map_win.win.setpos(i + 3, 3)
      @map_win.win.addstr("#{line}\n")
    end

    @map_win.win.box('|', '-')
    @map_win.win.setpos(20, 3)

    return @map_win, @messages_win, @right_win
  end
end

class MapWindow
  attr_accessor :win

  def initialize(map)
    @win = Curses::Window.new(26, 70, 0, 0)
    @win.setpos(1, 3)
    @win.addstr("Map - #{map.name}")
    @win.setpos(22, 3)
    @win.addstr("WASD to move, C to exit")
    @win.setpos(23, 3)
    @win.addstr('P = Player, m = mob, c = item chest, $ = money chest, x = barrier')
    @win.refresh
  end
end

class MessagesWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(7, 70, 26, 0)
    @win.box('|', '-')
    @win.setpos(1, 3)
    @win.addstr('Messages')
    @win.setpos(2, 3)
    @win.refresh
  end
end

class RightWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(33, 30, 0, 70)
    @win.box('|', '-')
    @win.setpos(1, 3)
    @win.addstr('Stats/Equipped')
    @win.setpos(3, 3)
    @win.refresh
  end
end