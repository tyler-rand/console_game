# Application helper methods
def colorize_item_name(item)
  quality_color = {
    'Shitty' => 90, 'Normal' => 3, 'Magic' => 92, 'Rare' => 93, 'Unique' => 94, 'Legendary' => 91
  }

  item.name.colorize(quality_color[item.quality])
end

# THIS BELONGS ELSEWHERE
def level_exp(level)
  level_exp = { 1 => 10, 2 => 20, 3 => 30, 4 => 40, 5 => 50 }
  level_exp[level]
end

def map_colors_hash(char) # does this need to be a method or can the hash just be defined as a var?
  colors_hash = {
    '.' => Curses::COLOR_GREEN, 'P' => Curses::COLOR_BLUE, '$' => Curses::COLOR_WHITE,
    'x' => Curses::COLOR_RED, 'c' => Curses::COLOR_YELLOW, 'm' => Curses::COLOR_MAGENTA,
    'o' => Curses::A_NORMAL, '_' => Curses::A_NORMAL, 'Q' => Curses::A_NORMAL,
    'W' => Curses::A_NORMAL, 'A' => Curses::A_NORMAL
  }
  colors_hash[char]
end

def messages_colors_hash(msg)
  msg_color_hash = {
    'normal' => Curses::A_NORMAL, 'green' => Curses::COLOR_GREEN, 'red' => Curses::COLOR_RED,
    'yellow' => Curses::COLOR_YELLOW
  }
  msg_color_hash.default = Curses::A_NORMAL
  msg_color_hash[msg]
end

def map_menu
  # list maps
  @main_win.refresh_display(title: @player.name) { Map.list_all(@main_win) }

  # query user for map name to load, append it to last msg in log
  messages = [Message.new('> Enter a map name to load', 'yellow'), Message.new('--> ', 'normal')]
  $message_log.show_msgs(messages)
  map_name_input = $message_win.win.getstr.titleize
  $message_log.append(map_name_input)

  # check map name and build map
  map_name = Map.verify_name(map_name_input)
  @map = Map.load(map_name)
  @main_win.build_map(@map)
  @player.find_location(@map.current_map)

  messages = [Message.new("> #{@map.name} loaded successfully, player: #{@player.location}", 'green')]
  $message_log.show_msgs(messages)

  # get input and move player loop
  loop do
    movement_input = @main_win.getch_no_echo
    map_movement = MapMovement.new(@map, @player, movement_input)
    break if @player.location == []
    map_movement.move
    @right_win.build_display(@player)
    @main_win.display_colored_map(@map)
  end
end

def bag_menu
  @main_win.refresh_display(title: @player.name) { @player.inventory.list(@main_win) }

  messages = [Message.new('> Enter a command and number seperated by a space (Ex. Equip 2)', 'yellow'),
              Message.new('--> ', 'normal')]
  $message_log.show_msgs(messages)

  user_bag_input = $message_win.win.getstr.split
  $message_log.append(user_bag_input.join(' '))

  command  = user_bag_input[0].downcase
  item_num = user_bag_input[1].to_i

  interaction = InventoryInteractor.new(@player, command, item_num)
  interaction.execute if (command == 'equip' && interaction.equip_is_confirmed?) || command != 'equip'
end

def equipped_menu
  @player.equipped.list(@main_win)
  messages = [Message.new('> Press any key to continue.', 'yellow')]
  $message_log.show_msgs(messages)
  @main_win.getch_no_echo
end

def stats_menu
  messages = [Message.new('> In progress...', 'yellow'), Message.new('> Press any key to continue.', 'yellow')]
  $message_log.show_msgs(messages)
  @main_win.getch_no_echo
end

def skills_menu
  messages = [Message.new('> In progress...', 'yellow'), Message.new('> Press any key to continue.', 'yellow')]
  $message_log.show_msgs(messages)
  @main_win.getch_no_echo
end
