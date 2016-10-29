# handles a player moving on a map
class MapMovement
  attr_accessor :map, :player, :movement_input, :old_player_loc, :new_player_loc

  def initialize(map, player, movement_input)
    @map = map
    @player = player
    @movement_input = movement_input
    @old_player_loc = player.location
    @new_player_loc = find_new_player_loc(movement_input)
  end

  def execute
    action = player_movement

    return action unless action.nil?

    player.location = map.find_player
    nil
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

  def player_movement # each method must return an array of action symbols or nil
    case map.current_map[new_player_loc[0]][new_player_loc[1]]
    when '.' then land_on_open_space
    when 'c' then land_on_chest
    when '$' then land_on_money
    when Mob::MAP_ICON then land_on_mob
    when Quest::MAP_ICON then land_on_quest
    when Vendor::MAP_ICON then land_on_vendor
    when '^' then show_next_map
    end
  end

  def land_on_open_space
    move_player_icon(new_player_loc, player.location)
    nil # return action
  end

  def land_on_chest
    player.inventory.add_random_items(map.level, qty: 3)
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

    [:engage_mob] # return action array
  end

  def land_on_quest
    return [:open_quest] if VendorInteractor.open_vendor?(:quest)
    nil
  end

  def land_on_vendor
    return [:open_shop] if VendorInteractor.open_vendor?(:shop)
    nil
  end

  def show_next_map
    i = Map.names.index(map.name)

    [:show_next_map, Map.names[i + 1]] # return action array
  end

  def move_player_icon(new_player_loc, old_player_loc)
    map.current_map[new_player_loc[0]][new_player_loc[1]] = Player::MAP_ICON
    map.current_map[old_player_loc[0]][old_player_loc[1]] = '.'
  end
end
