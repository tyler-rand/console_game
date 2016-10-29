# map specific interations from the games main menu
class MapMenu
  MAP_LEGEND = 'l'.freeze
  QUEST_MENU = 'q'.freeze
  EQUIPPED_MENU = 'e'.freeze
  BAG_MENU = 'b'.freeze
  EXIT = 'c'.freeze
  MOVE_PLAYER = %w(w a s d).freeze

  def initialize(action_win, main_win, right_win, player)
    @action_win = action_win
    @main_win   = main_win
    @right_win  = right_win
    @player     = player
  end

  def menu
    # list maps
    @action_win.refresh_display { Map.list_all(@action_win) }

    # query user for map name and validate
    map_name = map_name_query
    @action_win.refresh_display
    return if map_name.upcase == 'BACK'

    display_map(map_name)
    move_player_loop
  end

  private

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
    @map_displayer = MapDisplayer.new(@map, @main_win.win)

    @main_win.build_map(@map_displayer)
    @player.location = @map.find_player

    msgs = [Message.new("> #{@map.name} loaded successfully, player: #{@player.location}", 'green')]
    $message_win.display_messages(msgs)
  end

  def move_player_loop
    loop do
      movement_input = @main_win.getch_no_echo

      case movement_input
      when BAG_MENU
        next bag_menu
      when EQUIPPED_MENU
        next equipped_menu
      when QUEST_MENU
        next quest_menu
      when MAP_LEGEND
        next map_legend
      when *MOVE_PLAYER
        move_player(movement_input)
      when EXIT, @player.location == []
        break
      else
        movement_input_error
      end
    end
  end

  def move_player(movement_input)
    @map_movement = MapMovement.new(@map, @player, movement_input)
    action = @map_movement.execute

    map_movement_action(action) unless action.nil?

    @right_win.build_display(@player)

    @map_displayer.update_player_location(@player.location, @map_movement.old_player_loc)
  end

  def map_movement_action(action)
    case action[0]
    when :show_next_map then display_map(action[1])
    when :engage_mob    then engage_mob
    when :open_shop     then open_shop
    when :open_quest    then open_quest
    end
  end

  def engage_mob
    battle_displayer = BattleDisplayer.new(@action_win.win)
    battle = Battle.new(battle_displayer, @map_movement)
    battle.engage
  end

  def open_shop
    vendor = @map.vendors.find { |v| v.location == @map_movement.new_player_loc }
    interaction = VendorInteractor.new(vendor: vendor, player: @player, win: @action_win)
    interaction.engage
    @action_win.refresh_display
  end

  def open_quest
    quest = @map.quests.find { |q| q.location == @map_movement.new_player_loc }
    @player.quest_log.quests << quest
    msgs = [Message.new(quest.dialogue, 'yellow'),
            Message.new(quest.formatted_rewards, 'yellow')]
    $message_win.display_messages(msgs)
  end

  def movement_input_error
    msgs = [Message.new('> Error, command not recognized.', 'red')]
    $message_win.display_messages(msgs)
  end
end
