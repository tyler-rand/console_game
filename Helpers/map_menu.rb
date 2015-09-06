def map_menu
  # list maps
  @main_win.refresh_display(title: @player.name) { Map.list_all(@main_win) }

  # query user for map name and validate
  loop do
    map_name = prompt_map_name_to_load
    break if map_name_valid?(map_name)
  end

  display_map(map_name)
  move_player_loop
end

def prompt_map_name_to_load
  msgs = [Message.new('> Enter a map name to load', 'yellow'),
          Message.new('--> ', 'normal')]
  $message_win.display_messages(msgs)

  map_name_input = $message_win.win.getstr.titleize
  $message_win.message_log.append(map_name_input)

  map_name_input
end

def map_name_valid?(map_name)
  if Map.names.include?(map_name)
    true
  else
    msgs = [Message.new('> Map name error, try again.', 'red')]
    $message_win.display_messages(msgs)
    false
  end
end

def display_map(map_input)
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

    map_movement.execute
    @right_win.build_display(@player)
    @main_win.display_colored_map(@map)
  end
end
