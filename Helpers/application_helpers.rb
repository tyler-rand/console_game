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
  msgs = [Message.new('> Press any key to continue.', 'yellow')]
  $message_win.display_messages(msgs)
  @action_win.getch_no_echo
  @action_win.refresh_display
end

def stats_menu
  msgs = [Message.new('> In progress...', 'yellow'),
          Message.new('> Press any key to continue.', 'yellow')]
  $message_win.display_messages(msgs)
  @action_win.getch_no_echo
end
