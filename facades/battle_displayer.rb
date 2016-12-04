# displays and updates battle info
class BattleDisplayer
  attr_reader :win

  def initialize(win)
    @win = win
  end

  def refresh(battle)
    win.setpos(1, 19)
    win.addstr('BATTLE')
    colored_player_health(battle.player)
    colored_mob_health(battle.mob)
    win.refresh
  end

  def clear
    win.setpos(1, 19)
    win.addstr('      ')
    win.setpos(3, 8)
    win.addstr('             ')
    win.setpos(4, 14)
    win.addstr('   ')
    win.setpos(3, 24)
    win.addstr('          ')
    win.setpos(4, 28)
    win.addstr('   ')
    win.refresh
  end

  private

  def colored_player_health(player)
    win.setpos(3, 8)
    win.addstr('Player health')
    win.setpos(4, 14)
    win.addstr('   ')
    win.setpos(4, 14)
    win.attron(Curses.color_pair(health_color(player))) { win.addstr(player.health.to_s) }
  end

  def colored_mob_health(mob)
    win.setpos(3, 24)
    win.addstr('Mob health')
    win.setpos(4, 28)
    win.addstr('   ')
    win.setpos(4, 28)
    win.attron(Curses.color_pair(health_color(mob))) { win.addstr(mob.health.to_s) }
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
