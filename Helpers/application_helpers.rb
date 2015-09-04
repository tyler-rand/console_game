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

def map_menu
  # list maps
  @main_win.refresh_display(title: @player.name) { Map.list_all(@main_win) }
  # query user for map name to load, append it to last msg in log
  map_name = prompt_map_name_to_load
  # check map name and build map
  display_map(map_name)
  # get input and move player loop
  move_player_loop
end

def bag_menu
  @main_win.refresh_display(title: @player.name) { @player.inventory.list(@main_win) }

  user_bag_input = prompt_bag_command
  command        = user_bag_input[0].downcase
  item_num       = user_bag_input[1].to_i

  interaction = InventoryInteractor.new(@player, command, item_num)
  interaction.execute if (command == 'equip' && interaction.equip_confirmed?) || command != 'equip'
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
  msgs = [Message.new('> In progress...', 'yellow'),
          Message.new('> Press any key to continue.', 'yellow')]
  $message_win.display_messages(msgs)
  @main_win.getch_no_echo
end

def prompt_map_name_to_load
  msgs = [Message.new('> Enter a map name to load', 'yellow'),
          Message.new('--> ', 'normal')]
  $message_win.display_messages(msgs)
  map_name_input = $message_win.win.getstr.titleize
  $message_win.message_log.append(map_name_input)

  map_name_input
end

def display_map(map_input)
  map_name = Map.verify_name(map_input)
  @map = Map.load(map_name)
  @main_win.build_map(@map)
  @player.find_location(@map.current_map)

  msgs = [Message.new("> #{@map.name} loaded successfully, player: #{@player.location}", 'green')]
  $message_win.display_messages(msgs)
end

def move_player_loop
  loop do
    movement_input = @main_win.getch_no_echo
    map_movement = MapMovement.new(@map, @player, movement_input)
    break if @player.location == []
    map_movement.move
    @right_win.build_display(@player)
    @main_win.display_colored_map(@map)
  end
end

def prompt_bag_command
  msgs = [Message.new('> Enter a command and number seperated by a space (Ex. Equip 2)', 'yellow'),
          Message.new('--> ', 'normal')]
  $message_win.display_messages(msgs)
  user_bag_input = $message_win.win.getstr.split
  $message_win.message_log.append(user_bag_input.join(' '))

  user_bag_input
end
