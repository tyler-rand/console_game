def skills_menu
  @main_win.refresh_display(title: "Skills Menu") { Skill.list(@main_win.win) }
  
  msgs = [Message.new("> Skill points remaining: #{@player.unused_skills}", 'yellow'),
          Message.new('> Choose a skill:', 'yellow'),
          Message.new('--> ', 'normal')]
  $message_win.display_messages(msgs)
  
  skills_menu_input = $message_win.win.getstr.split
  $message_win.message_log.append(skills_menu_input.join(' '))
end
