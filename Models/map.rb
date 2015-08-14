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

  def colorize
    x_color  = 'x'.colorize(34)
    m_color  = 'm'.colorize(91)
    # $$ = '$'.colorize(93)
    c_color  = 'c'.colorize(93)
    p_color  = 'p'.colorize(92)
    o_color  = 'o'.colorize(34)

    colorized_map = current_map.map do |line|
      line.gsub(/[xmcoP]/, 'x' => x_color, 'm' => m_color, 'c' => c_color, 'o' => o_color, 'P' => p_color)
    end

    colorized_map
  end

  def new_player_loc_from_input(player, user_input) # rename, rewrite
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
        puts 'Error, command not recognized.'.colorize(101)
        puts "#{'WASD'.colorize(93)} to move, #{'C'.colorize(91)} to exit"
        new_player_loc = player.location
        input_state = 1
      end
    end

    new_player_loc
  end

  def show_map_for_player
    puts "\n"
    puts colorize
    puts '--'
    puts "#{'WASD'.colorize(93)} to move, #{'C'.colorize(91)} to exit"
    puts '--'
  end

  def move_player(player:, new_player_loc:)
    messages = []

    case current_map[new_player_loc[0]][new_player_loc[1]]
    when '.'
      current_map[new_player_loc[0]][new_player_loc[1]]   = 'P'
      current_map[player.location[0]][player.location[1]] = '.'
    when 'c'
      player.inventory.add_items(level)
      current_map[new_player_loc[0]][new_player_loc[1]]   = 'P'
      current_map[player.location[0]][player.location[1]] = '.'
      messages << '> Picked up items from a chest.'
    when '$'
      player.inventory.add_money(10)
      current_map[new_player_loc[0]][new_player_loc[1]]   = 'P'
      current_map[player.location[0]][player.location[1]] = '.'
      messages << '> Picked up some money.'
    when 'm'
      messages << '> A mob appears! Kill it!'
      player.engage_mob(self, new_player_loc)
    when 'x'
      messages << '> Can\'t move to spaces with \'x\''
    else
      # exception
    end
    player.set_location(current_map)
    messages
  end
end
