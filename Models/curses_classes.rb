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
    display_colored_map(map)

    win.setpos(20, 3)
    win.addstr('WASD to move, C to exit')
    win.setpos(22, 3)
    win.addstr('P = Player, m = mob, c = item chest, $ = money chest, x = barrier')
    win.box('j', '~')
    win.setpos(0, 35-map.name.length/2)
    win.addstr("Map - #{map.name}")
  end

  def display_colored_map(map)
    indexed_map = map.current_map.each_with_index.map{ |line, i| [line, i] }

    indexed_map.each do |line, i|
      win.setpos(i + 1, 2)
      line_ary = line.split('')

      line_ary.each do |c|
        win.attron(Curses.color_pair(map_colors_hash(c))) { win.addch(c) }
      end
    end
  end

  def box_with_player_name(name)
    win.box('j', '~')
    win.setpos(0, 29-name.length/2)
    win.addstr("ConsoleRPG - #{name}")
  end
end

class MessagesWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(10, 70, 26, 0)
    box_with_title
    @win.refresh
  end

  def box_with_title
    win.box('j', '~')
    win.setpos(0, 28)
    win.addstr('Input/Message Log')
    win.setpos(1, 2)
  end

  def print_log(message_log)
    line_num = 1

    message_log.display_range.each do |line|
      message = message_log.log[line][0]

      win.setpos(line_num, 2)
      win.addstr(message)
      line_num += 1
    end
  end
end

class RightWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(36, 30, 0, 70)
    @win.box('j', '~')
    @win.setpos(0, 8)
    @win.addstr('Stats/Equipped')
    @win.setpos(1, 2)
    @win.refresh
  end

  def build_display(player)
    win.setpos(2, 15-player.name.length/2)
    win.addstr(player.name.upcase)
    win.setpos(4, 2)
    win.addstr("Level #{player.level} #{player.species} #{player.type}")
    win.setpos(6, 2)
    win.addstr("Health: #{player.health}/#{player.max_health}")
    win.setpos(7, 2)
    win.addstr("Energy: #{player.energy}/#{player.max_energy}")
    win.setpos(8, 2)
    win.addstr("XP: #{player.current_exp}/#{player.max_exp}")
    win.setpos(10, 2)
    win.addstr("Armor: #{player.armor}")
    win.setpos(11, 2)
    win.addstr("Damage: #{player.damage}")
    win.setpos(12, 2)
    win.addstr("Crit chance: #{player.crit_chance}%")
    win.setpos(14, 2)
    win.addstr("Strength: #{player.strength}")
    win.setpos(15, 2)
    win.addstr("Agility: #{player.agility}")
    win.setpos(16, 2)
    win.addstr("Intelligence: #{player.intelligence}")
    win.setpos(18, 2)
    win.addstr("Money: #{player.inventory.money}")
    win.refresh
  end
end
