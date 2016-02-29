def map_menu
  # list maps
  @action_win.refresh_display { Map.list_all(@action_win) }

  # query user for map name and validate
  map_name = map_name_query
  @action_win.refresh_display
  return if map_name.upcase == 'BACK'

  display_map(map_name)
  move_player_loop
end

def map_name_query
  loop do
    map_name = prompt_map_name_to_load
    break map_name if map_name_valid?(map_name)
  end
end

def prompt_map_name_to_load
  msgs = [Message.new("> Enter a map name to load, or 'back' to exit.", 'yellow'),
          Message.new('--> ', 'normal')]
  $message_win.display_messages(msgs)

  map_name_input = $message_win.win.getstr.titleize
  $message_win.message_log.append(map_name_input)

  map_name_input
end

def map_name_valid?(map_name)
  if Map.names.include?(map_name) || map_name.upcase == 'BACK'
    true
  else
    msgs = [Message.new('> Map name error, try again.', 'red')]
    $message_win.display_messages(msgs)
    false
  end
end

def display_map(map_name)
  @map = Map.load(map_name)
  @map_display = MapDisplayer.new(@map, @main_win.win)

  @main_win.build_map(@map_display)
  @player.location = @map.find_player

  msgs = [Message.new("> #{@map.name} loaded successfully, player: #{@player.location}", 'green')]
  $message_win.display_messages(msgs)
end

def move_player_loop
  loop do
    movement_input = @main_win.getch_no_echo

    case movement_input
    when bag_menu_input
      next bag_menu
    when equipped_menu_input
      next equipped_menu
    when movement_input_exit
      break
    else
      move_player(movement_input)
      @right_win.build_display(@player)
      break if @player.location == []
      @map_display.display_colored_map
    end
  end
end

def move_player(movement_input)
  if movement_input_valid?(movement_input)
    @map_movement = MapMovement.new(@map, @player, movement_input)
    action = @map_movement.execute

    map_movement_action(action) unless action.nil?
  else
    movement_input_error
  end
end

def map_movement_action(action)
  case action[0]
  when :show_next_map
    display_map(action[1])
  when :engage_mob
    battle_displayer = BattleDisplayer.new(@action_win.win)
    battle = Battle.new(battle_displayer, @map_movement)
    battle.engage
  when :open_shop
    vendor = @map.vendors.find { |v| v.location == @map_movement.new_player_loc }
    interaction = VendorInteractor.new(vendor: vendor, player: @player, win: @action_win)
    interaction.engage
    @action_win.refresh_display
  end
end

def movement_input_valid?(movement_input)
  %w(w a s d).include?(movement_input)
end

def movement_input_exit
  'c'
end

def bag_menu_input
  'b'
end

def equipped_menu_input
  'e'
end

def movement_input_error
  msgs = [Message.new('> Error, command not recognized.', 'red')]
  $message_win.display_messages(msgs)
end
