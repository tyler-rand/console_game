# displays and updates battle info
class BattleDisplayer
  attr_accessor :win

  def initialize(win)
    @win = win
  end

  def refresh(battle)
    win.setpos(1, 39)
    win.addstr('BATTLE')
    colored_player_health(battle.player)
    colored_mob_health(battle.mob)
    win.refresh
  end

  def clear
    win.setpos(1, 39)
    win.addstr('      ')
    win.setpos(3, 28)
    win.addstr('             ')
    win.setpos(4, 34)
    win.addstr('   ')
    win.setpos(3, 44)
    win.addstr('          ')
    win.setpos(4, 48)
    win.addstr('   ')
    win.refresh
  end

  private

  def colored_player_health(player)
    win.setpos(3, 28)
    win.addstr('Player health')
    win.setpos(4, 34)
    win.addstr('   ')
    win.setpos(4, 34)
    win.attron(Curses.color_pair(health_color(player))) { win.addstr("#{player.health}") }
  end

  def colored_mob_health(mob)
    win.setpos(3, 44)
    win.addstr('Mob health')
    win.setpos(4, 48)
    win.addstr('   ')
    win.setpos(4, 48)
    win.attron(Curses.color_pair(health_color(mob))) { win.addstr("#{mob.health}") }
  end

  def health_color(char)
    health_percent = (char.health.to_f / char.max_health.to_f) * 100

    if health_percent <= 25
      Curses::COLOR_RED
    elsif health_percent <= 65
      Curses::COLOR_YELLOW
    else
      Curses::COLOR_GREEN
    end
  end
end
