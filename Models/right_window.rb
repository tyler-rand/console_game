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
    display_all_info(player)
    win.refresh
  end

  private

  def display_all_info(player)
    display_name(player)
    display_life_info(player)
    display_xp_info(player)
    display_battle_stats_info(player)
    display_stats_info(player)
    display_bag_info(player)
  end

  def display_name(player)
    win.setpos(2, 15 - player.name.length / 2)
    win.addstr(player.name.upcase)
  end

  def display_life_info(player)
    win.setpos(win.cury + 2, 2)
    win.addstr("Health: #{player.health}/#{player.max_health}")
    win.setpos(win.cury + 1, 2)
    win.addstr("Energy: #{player.energy}/#{player.max_energy}")
  end

  def display_xp_info(player)
    win.setpos(win.cury + 2, 2)
    win.addstr("Level #{player.level} #{player.species} #{player.type}")
    win.setpos(win.cury + 1, 2)
    win.addstr("XP: #{player.current_exp}/#{player.max_exp}")
  end

  def display_battle_stats_info(player)
    win.setpos(win.cury + 2, 2)
    win.addstr("Damage: #{player.damage}")
    win.setpos(win.cury + 1, 2)
    win.addstr("Crit chance: #{player.crit_chance}%")
    win.setpos(win.cury + 1, 2)
    win.addstr("Armor: #{player.armor}")
  end

  def display_stats_info(player)
    win.setpos(win.cury + 2, 2)
    win.addstr("Strength: #{player.strength}")
    win.setpos(win.cury + 1, 2)
    win.addstr("Agility: #{player.agility}")
    win.setpos(win.cury + 1, 2)
    win.addstr("Intelligence: #{player.intelligence}")
  end

  def display_bag_info(player)
    win.setpos(win.cury + 2, 2)
    win.addstr("Money: #{player.inventory.money}")
  end
end
