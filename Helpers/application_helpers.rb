##################################################
### METHODS USED BY MAIN (console_rpg.rb) FILE ###
##################################################

def main_menu_query
  msgs = [Message.new('> MAP | BAG | EQUIPPED | STATS | SKILLS | EXIT', 'yellow'),
          Message.new('--> ', 'normal')]
  $message_win.display_messages(msgs)

  input = $message_win.win.getstr.upcase
  $message_win.message_log.append(input)

  input
end

def equipped_menu
  @player.equipped.list(@action_win)
  press_any_key
end

def quest_menu
  @player.quest_log.list(@action_win)
  press_any_key
end

def map_legend
  list_legend(@action_win)
  press_any_key
end

def stats_menu
  # @player.stats.list(@action_win)
  press_any_key
end

def list_legend(window)
  window.win.setpos(1, 2)
  window.win.addstr("---- Map Legend ----")
  window.win.setpos(3, 3)

  display_legend(window.win)

  window.win.refresh
end

def display_legend(win)
  win.addstr('P - Player')
  win.setpos(win.cury + 1, 3)
  win.addstr('m - Monster')
  win.setpos(win.cury + 1, 3)
  win.addstr('N - NPC Vendor')
  win.setpos(win.cury + 1, 3)
  win.addstr('Q - Questgiver')
  win.setpos(win.cury + 1, 3)
  win.addstr('c - Item Chest')
  win.setpos(win.cury + 1, 3)
  win.addstr('$ - Money Chest')
  win.setpos(win.cury + 1, 3)
  win.addstr('^ - Next Map')
end

def press_any_key
  msgs = [Message.new('> Press any key to continue.', 'yellow')]
  $message_win.display_messages(msgs)
  @action_win.getch_no_echo
  @action_win.refresh_display
end
