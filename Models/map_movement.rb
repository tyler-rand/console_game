# handles a player moving on a map
class MapMovement
  attr_accessor :map, :player, :movement_input, :new_player_loc

  #
  ## INSTANCE METHODS
  #

  def initialize(map, player, movement_input)
    @map = map
    @player = player
    @movement_input = movement_input
    @new_player_loc = find_new_player_loc(movement_input)
  end

  def find_new_player_loc(movement_input)
    if %w(w a s d).include?(movement_input)
      player_loc = player.find_new_loc(movement_input)
    elsif movement_input == 'c'
      player.location = []
      player_loc = player.location
    else
      messages = [Message.new('> Error, command not recognized.', 'red'), Message.new('> \'WASD\' to move, \'C\' to exit', 'yellow')]
      player_loc = player.location
      $message_log.show_msgs(messages)
    end

    player_loc
  end

  def move
    case map.current_map[new_player_loc[0]][new_player_loc[1]]
    when '.'
      map.current_map[new_player_loc[0]][new_player_loc[1]]   = 'P'
      map.current_map[player.location[0]][player.location[1]] = '.'
    when 'c'
      player.inventory.add_items(map.level)
      map.current_map[new_player_loc[0]][new_player_loc[1]]   = 'P'
      map.current_map[player.location[0]][player.location[1]] = '.'
      messages = [Message.new('> Picked up items from a chest.', 'green')]
      $message_log.show_msgs(messages)
      yield
    when '$'
      player.inventory.add_money(10)
      map.current_map[new_player_loc[0]][new_player_loc[1]]   = 'P'
      map.current_map[player.location[0]][player.location[1]] = '.'
      messages = [Message.new('> Picked up some money.', 'green')]
      $message_log.show_msgs(messages)
      yield
    when 'm'
      messages = [Message.new('> A mob appears! Kill it!', 'yellow'), Message.new('> ATTACK | BAG | RUN', 'yellow'), Message.new('--> ', 'normal')]
      $message_log.show_msgs(messages)
      player.engage_mob(map, new_player_loc) { yield }
    when 'x'
      messages = [Message.new('> Can\'t move to spaces with \'x\'', 'red')]
      $message_log.show_msgs(messages)
    else
      # exception
    end

    player.find_location(map.current_map)
  end

end