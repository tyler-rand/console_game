require 'curses'

# right window, displays player stats
class RightWindow
  attr_accessor :win

  def initialize
    @win = Curses::Window.new(36, 30, 0, 70)
    box_with_title
    @win.refresh
  end

  def box_with_title
    @win.box('|', '-')
    @win.setpos(0, 8)
    @win.attron(Curses.color_pair(3)) { @win.addstr('Stats/Equipped') }
  end

  def build_display(player)
    win.clear
    box_with_title
    win.setpos(2, 15 - player.name.length / 2)
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
