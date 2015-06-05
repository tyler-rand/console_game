# map
class Map
  attr_accessor :id, :name, :level, :grid, :current_map, :mobs

  #
  ## CLASS METHODS
  #

  def self.list_all
    maps = YAML.load_stream(open('MapsDB.yml'))

    puts ' -------------'
    puts ' --- MAPS ----'
    puts ' -------------'
    puts maps.map(&:name)
    puts ' -------------'
    maps
  end

  #
  ## INSTANCE METHODS
  #

  def initialize(name:, level:, grid:)
    @id          = object_id
    @name        = name
    @level       = level.to_i
    @grid        = grid
    @current_map = YAML.load(File.open(grid)).split(' ')
    @mobs        = load_mobs
  end

  def save
    File.open('MapsDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  def load_mobs
    mob_positions = []
    mob_objects   = []

    self.current_map.map do |line|
      line_num = current_map.index(line)

      line.split('').each_with_index.select { |c| mob_positions << [line_num,c[1]] if c[0] == 'm' }
    end

    mob_positions.length.times { mob_objects << Mob.roll_new(self) }
    mobs = mob_positions.zip(mob_objects).to_h

    mobs
  end

  def print_colorized
    x_color  = 'x'.colorize(34)
    m_color  = 'm'.colorize(91)
    #$$ = '$'.colorize(93)
    c_color  = 'c'.colorize(93)
    p_color  = 'p'.colorize(92)
    o_color  = 'o'.colorize(34)

    colorized_map = current_map.map do |line| 
      line.gsub(/[xmcoP]/, 'x' => x_color, 'm' => m_color, 'c' => c_color, 'o' => o_color, 'P' => p_color)
    end
    puts colorized_map
  end

  def new_player_loc_from_input(player) # rename, rewrite
    player_loc  = find_player_loc(current_map)  
    input_state = 0  

    while input_state == 0
      user_input = STDIN.getch

      if %w(w a s d).include?(user_input)
        new_player_loc = find_new_player_loc(user_input, player_loc, current_map)
        input_state    = 1
      elsif user_input == 'c'
        current_map[player_loc[0]][player_loc[1]] = '.'
        new_player_loc = player_loc
        input_state    = 1
      else
        puts 'Error, command not recognized.'.colorize(101)
        puts "#{'WASD'.colorize(93)} to move, #{'C'.colorize(91)} to exit"
      end
    end

    return player_loc, new_player_loc
  end

  def show_map_for_player
    puts "\n"
    print_colorized
    puts '--'
    puts "#{'WASD'.colorize(93)} to move, #{'C'.colorize(91)} to exit"
    puts '--'
  end

  def move_player(player:, player_loc:, new_player_loc:)
    case current_map[new_player_loc[0]][new_player_loc[1]]
    when '.'
      current_map[new_player_loc[0]][new_player_loc[1]] = 'P'
      current_map[player_loc[0]][player_loc[1]]         = '.'
    when 'c'
      player.inventory.add_items(level)
      current_map[new_player_loc[0]][new_player_loc[1]] = 'P'
      current_map[player_loc[0]][player_loc[1]]         = '.'
    when '$'
      player.inventory.add_money(10)
      current_map[new_player_loc[0]][new_player_loc[1]] = 'P'
      current_map[player_loc[0]][player_loc[1]]         = '.'
    when 'm'
      player.engage_mob(self, player_loc, new_player_loc)
    when 'x'
      puts 'Can\'t move to spaces with \'x\''.colorize(101)
    else
      # exception
    end
    print '-->'
  end

end
