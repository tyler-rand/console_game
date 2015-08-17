# map
class Map
  attr_accessor :id, :name, :level, :file, :current_map, :mobs

  #
  ## CLASS METHODS
  #

  def self.all; YAML.load_stream(open('MapsDB.yml')) end

  def self.names_ary; Map.all.map(&:name) end

  def self.list_all(window)
    maps = Map.all
    i = 4

    window.win.setpos(2, 2)
    window.win.addstr("---- MAPS ---\n")
    window.win.setpos(3, 2)
    window.win.addstr("-------------\n")
    maps.map(&:name).each { |m| window.win.setpos(i, 2); window.win.addstr(m); i += 1 }
    window.win.refresh
    maps
  end

  #
  ## INSTANCE METHODS
  #

  def initialize(options = {})
    @id          = object_id
    @name        = options[:name]
    @level       = options[:level].to_i
    @file        = options[:file]
    @current_map = load_current_map
    @mobs        = load_mobs
  end

  def save; File.open('MapsDB.yml', 'a') { |f| f.write(to_yaml) } end

  def load_current_map; self.current_map = YAML.load(File.open(file)).split end

  def load_mobs
    mob_positions = []
    mobs          = []

    current_map.each do |line|
      line_num = current_map.index(line)

      line.split('').each_with_index.select { |c| mob_positions << [line_num, c[1]] if c[0] == 'm' }
    end

    mob_positions.each { |pos| mobs << Mob.roll_new(self, pos) }
    self.mobs = mobs

    self.mobs
  end

  def new_player_loc_from_input(player, user_input) # rename, rewrite, put elsewhere
    input_state = 0

    while input_state == 0
      if %w(w a s d).include?(user_input)
        new_player_loc = player.find_new_loc(user_input, current_map)
        input_state = 1
      elsif user_input == 'c'
        player.location = []
        new_player_loc = player.location
        input_state = 1
      else
        messages = [['> Error, command not recognized.', 'red'], ['> \'WASD\' to move, \'C\' to exit', 'yellow']]
        $game.message_log.add_msgs(messages)
        $messages_win.display_messages($game.message_log)
        new_player_loc = player.location
        input_state = 1
      end
    end

    new_player_loc
  end

  def move_player(player:, new_player_loc:)
    messages = []
    action = nil

    case current_map[new_player_loc[0]][new_player_loc[1]]
    when '.'
      current_map[new_player_loc[0]][new_player_loc[1]]   = 'P'
      current_map[player.location[0]][player.location[1]] = '.'
    when 'c'
      player.inventory.add_items(level)
      current_map[new_player_loc[0]][new_player_loc[1]]   = 'P'
      current_map[player.location[0]][player.location[1]] = '.'
      messages << ['> Picked up items from a chest.', 'green']
    when '$'
      player.inventory.add_money(10)
      current_map[new_player_loc[0]][new_player_loc[1]]   = 'P'
      current_map[player.location[0]][player.location[1]] = '.'
      messages << ['> Picked up some money.', 'green']
    when 'm'
      messages = [['> A mob appears! Kill it!', 'yellow'], ['> ATTACK | BAG | RUN', 'yellow'], ['-->', 'normal']]
      action = 'engage_mob'
    when 'x'
      messages << ['> Can\'t move to spaces with \'x\'', 'red']
    else
      # exception
    end

    player.set_location(current_map)
    return messages, action
  end
end
