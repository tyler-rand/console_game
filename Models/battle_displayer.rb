# displays and updates battle info
class BattleDisplayer
  attr_accessor :win

  def initialize(win)
    @win = win
  end

  def refresh(battle)
    win.setpos(1, 39)
    win.addstr('BATTLE')
    win.setpos(3, 28)
    win.addstr('Player health')
    win.setpos(4, 34)
    win.addstr('   ')
    win.setpos(4, 34)
    win.addstr("#{battle.player.health}")
    win.setpos(3, 44)
    win.addstr('Mob health')
    win.setpos(4, 48)
    win.addstr('   ')
    win.setpos(4, 48)
    win.addstr("#{battle.mob.health}")
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
end
