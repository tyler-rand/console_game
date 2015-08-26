# map
class Map
  attr_accessor :id, :name, :level, :file, :current_map, :mobs

  #
  ## CLASS METHODS
  #

  def self.all
    YAML.load_stream(open('MapsDB.yml'))
  end

  def self.load(map)
    map = Map.all.find { |m| m.name == map }
  end

  def self.names_ary
    Map.all.map(&:name)
  end

  def self.list_all(window)
    maps = Map.all
    line = 4

    window.win.setpos(2, 2)
    window.win.addstr("---- MAPS ---\n")
    window.win.setpos(3, 2)
    window.win.addstr("-------------\n")
    maps.map(&:name).each do |map_name|
      window.win.setpos(line, 2)
      window.win.addstr(map_name)
      line += 1
    end
  end

  def self.verify_name(map_name)
    loop do
      return map_name if Map.names_ary.include?(map_name)
      messages = [Message.new('> Map name error, try again.', 'red'), Message.new('--> ', 'normal')]
      $message_log.show_msgs(messages)

      map_name = $message_win.win.getstr.titleize
      $message_log.append(map_name)
    end
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

  def save
    File.open('MapsDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  def load_current_map
    self.current_map = YAML.load(File.open(file)).split
  end

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

  def move_player(new_player_loc, old_player_loc)
    current_map[new_player_loc[0]][new_player_loc[1]] = 'P'
    current_map[old_player_loc[0]][old_player_loc[1]] = '.'
  end

end
