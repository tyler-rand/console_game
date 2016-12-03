# player input loop after a map has been loaded
class MapInputLoop
  attr_reader :map_menu, :map, :player, :main_win, :action_win, :map_displayer, :map_movement

  MAP_LEGEND = 'l'.freeze
  QUEST_MENU = 'q'.freeze
  EQUIPPED_MENU = 'e'.freeze
  BAG_MENU = 'b'.freeze
  EXIT = 'c'.freeze
  MOVE_PLAYER = %w(w a s d).freeze

  def initialize(map_menu:)
    @map_menu = map_menu
    @map = map_menu.map
    @player = map_menu.player
    @main_win = map_menu.main_win
    @action_win = map_menu.action_win
    @map_displayer = map_menu.map_displayer
  end

  def execute
    input_loop
  end

  private

  def input_loop
    loop do
      map_input = main_win.getch_no_echo

      case map_input
      when BAG_MENU      then next bag_menu
      when EQUIPPED_MENU then next equipped_menu
      when QUEST_MENU    then next quest_menu
      when MAP_LEGEND    then next map_legend
      when *MOVE_PLAYER  then move_player(map_input)
      when EXIT, player.location == []
        break
      else
        map_input_error
      end
    end
  end

  def move_player(map_input)
    @map_movement = MapMovement.new(map, player, map_input)
    action = map_movement.execute

    # dont refresh right window when no changes, player moved between empty spaces
    if action
      map_movement_action(action)
      $right_win.build_display(player)
    end

    # dont update player location during map transition
    unless action && action[0] == :show_next_map
      map_displayer.update_player_location(player.location, map_movement.old_player_loc)
    end
  end

  def map_movement_action(action)
    case action[0]
    when :show_next_map then refresh_map(map_name: action[1])
    when :engage_mob    then engage_mob
    when :open_shop     then open_shop
    when :open_quest    then open_quest
    end
  end

  def refresh_map(map_name:)
    @map = Map.load(map_name)
    @map_displayer = MapDisplayer.new(map, main_win.win)
    @map_menu = MapMenu.new(action_win, main_win, player).display_map(action[1])
  end

  def engage_mob
    battle_displayer = BattleDisplayer.new(action_win.win)
    battle = Battle.new(battle_displayer, map_movement)
    battle.engage
  end

  def open_shop
    vendor = map.vendors.find { |v| v.location == map_movement.new_player_loc }
    interaction = VendorInteractor.new(vendor: vendor, player: player, win: action_win)
    interaction.engage
    action_win.refresh_display
  end

  def open_quest
    quest = map.quests.find { |q| q.start_location == map_movement.new_player_loc }

    return quest_already_started(quest.name) if player.quest_log.quests.map(&:name).include?(quest.name)
    return quest_already_completed if player.quest_log.completed_quests.include?(quest.name)

    player.quest_log.add(quest)
  end

  def quest_already_started(quest_name)
    $message_win.display_messages(
      Message.new("> You're already on that quest! (#{quest_name})", 'yellow')
    )
  end

  def quest_already_completed
    $message_win.display_messages(
      Message.new('> You already completed that quest!', 'yellow')
    )
  end

  def map_input_error
    $message_win.display_messages(Message.new('> Error, command not recognized.', 'red'))
  end
end
