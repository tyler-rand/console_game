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

  def move
    case map.current_map[new_player_loc[0]][new_player_loc[1]]
    when '.'
      land_on_open_space
    when 'c'
      land_on_chest
    when '$'
      land_on_money
    when 'm'
      land_on_mob
    when 'x'
      land_on_wall
    else
      # exception
    end

    player.find_location(map.current_map)
  end

  def move_player(new_player_loc, old_player_loc)
    map.current_map[new_player_loc[0]][new_player_loc[1]] = 'P'
    map.current_map[old_player_loc[0]][old_player_loc[1]] = '.'
  end

  private

  def find_new_player_loc(movement_input)
    if %w(w a s d).include?(movement_input)
      player_loc = new_player_location(movement_input)
    elsif movement_input == 'c'
      player.location = []
      player_loc = player.location
    else
      player_loc = player.location
      messages = [Message.new('> Error, command not recognized.', 'red'),
                  Message.new('> \'WASD\' to move, \'C\' to exit', 'yellow')]
      $message_log.show_msgs(messages)
    end

    player_loc
  end

  def new_player_location(user_input)
    case user_input
    when 'w' # move up 1
      player_loc = [player.location[0] - 1, player.location[1]]
    when 'a' # move left 1
      player_loc = [player.location[0], player.location[1] - 1]
    when 's' # move down 1
      player_loc = [player.location[0] + 1, player.location[1]]
    when 'd' # move right 1
      player_loc = [player.location[0], player.location[1] + 1]
    end

    player_loc
  end

  def land_on_open_space
    move_player(new_player_loc, player.location)
  end

  def land_on_chest
    player.inventory.add_items(map.level)
    move_player(new_player_loc, player.location)
    messages = [Message.new('> Picked up items from a chest.', 'green')]
    $message_log.show_msgs(messages)
  end

  def land_on_money
    player.inventory.add_money(10)
    move_player(new_player_loc, player.location)
    messages = [Message.new('> Picked up some money.', 'green')]
    $message_log.show_msgs(messages)
  end

  def land_on_mob
    messages = [Message.new('> A mob appears! Kill it!', 'yellow'),
                Message.new('> ATTACK | BAG | RUN', 'yellow'), Message.new('--> ', 'normal')]
    $message_log.show_msgs(messages)

    battle = Battle.new(self)
    battle.engage
  end

  def land_on_wall
    messages = [Message.new('> Can\'t move to spaces with \'x\'', 'red')]
    $message_log.show_msgs(messages)
  end
end
