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

  def execute
    player_movement
    player.find_location(map.current_map)
  end

  private

  def find_new_player_loc(user_input)
    case user_input
    when 'w' then move_up
    when 'a' then move_left
    when 's' then move_down
    when 'd' then move_right
    end
  end

  def move_up
    [player.location[0] - 1, player.location[1]]
  end

  def move_down
    [player.location[0] + 1, player.location[1]]
  end

  def move_left
    [player.location[0], player.location[1] - 1]
  end

  def move_right
    [player.location[0], player.location[1] + 1]
  end

  def player_movement
    case map.current_map[new_player_loc[0]][new_player_loc[1]]
    when '.' then land_on_open_space
    when 'c' then land_on_chest
    when '$' then land_on_money
    when 'm' then land_on_mob
    when 'x' then land_on_wall
    end
  end

  def land_on_open_space
    move_player_icon(new_player_loc, player.location)
  end

  def land_on_chest
    player.inventory.add_items(map.level)
    move_player_icon(new_player_loc, player.location)

    msgs = [Message.new('> Picked up items from a chest.', 'green')]
    $message_win.display_messages(msgs)
  end

  def land_on_money
    player.inventory.add_money(10)
    move_player_icon(new_player_loc, player.location)

    msgs = [Message.new('> Picked up some money.', 'green')]
    $message_win.display_messages(msgs)
  end

  def land_on_mob
    msgs = [Message.new('> A mob appears! Kill it!', 'yellow')]
    $message_win.display_messages(msgs)

    battle = Battle.new(self)
    battle.engage
  end

  def land_on_wall
    msgs = [Message.new('> Can\'t move to spaces with \'x\'', 'red')]
    $message_win.display_messages(msgs)
  end

  def move_player_icon(new_player_loc, old_player_loc)
    map.current_map[new_player_loc[0]][new_player_loc[1]] = 'P'
    map.current_map[old_player_loc[0]][old_player_loc[1]] = '.'
  end
end
