##################################################
### METHODS USED BY MAIN (console_rpg.rb) FILE ###
##################################################

def main_menu_query
  msgs = [Message.new('> MAP | BAG | EQUIPPED | STATS | SKILLS', 'yellow'),
          Message.new('--> ', 'normal')]
  $message_win.display_messages(msgs)

  input = $message_win.win.getstr.upcase
  $message_win.message_log.append(input)

  input
end

def equipped_menu
  @player.equipped.list(@main_win)
  msgs = [Message.new('> Press any key to continue.', 'yellow')]
  $message_win.display_messages(msgs)
  @main_win.getch_no_echo
end

def stats_menu
  msgs = [Message.new('> In progress...', 'yellow'),
          Message.new('> Press any key to continue.', 'yellow')]
  $message_win.display_messages(msgs)
  @main_win.getch_no_echo
end

def skills_menu
  @main_win.refresh_display(title: "Skills Menu") { Skill.list(@main_win.win) }
  msgs = [Message.new("> Skill points remaining: #{@player.unused_skills}", 'yellow'),
          Message.new('> Choose a skill:', 'yellow'),
          Message.new('--> ', 'normal')]
  $message_win.display_messages(msgs)
  @main_win.getch_no_echo
end
