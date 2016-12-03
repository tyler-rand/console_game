# map specific interations from the games main menu
class MapMenu
  attr_reader :player, :action_win, :main_win, :map_displayer
  attr_accessor :map

  def initialize(action_win, main_win, player)
    @action_win = action_win
    @main_win   = main_win
    @player     = player
  end

  def menu
    list_maps

    map_name = map_name_query
    return if map_name.upcase == 'BACK'

    display_map(map_name)
    MapInputLoop.new(map_menu: self).execute
  end

  def display_map(map_name)
    @map = Map.load(map_name)
    @map_displayer = MapDisplayer.new(map, main_win.win)

    main_win.build_map(map_displayer)
    player.location = map.find_player

    $message_win.display_messages(
      Message.new("> #{map.name} loaded successfully, player: #{player.location}", 'green')
    )
  end

  private

  def list_maps
    action_win.refresh_display { Map.list_all(action_win) }
  end

  def map_name_query
    map_name = map_query_loop

    action_win.refresh_display
    map_name
  end

  def map_query_loop
    loop do
      map_name = prompt_map_name_to_load
      break map_name if name_valid?(map_name: map_name)
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

  def name_valid?(map_name:)
    if Map.names.include?(map_name) || map_name.upcase == 'BACK'
      true
    else
      $message_win.display_messages(Message.new('> Map name error, try again.', 'red'))
      false
    end
  end
end
