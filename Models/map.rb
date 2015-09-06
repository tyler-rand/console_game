# map
class Map
  attr_accessor :id, :name, :level, :file, :current_map, :mobs

  #
  ## CLASS METHODS
  #

  def self.open_all
    YAML.load_stream(open('db/MapsDB.yml'))
  end

  def self.load(map)
    map = Map.open_all.find { |m| m.name == map }
  end

  def self.names
    Map.open_all.map(&:name)
  end

  def self.list_all(window)
    maps = Map.open_all
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
    File.open('db/MapsDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  def remove_mob(location)
    current_map[location[0]][location[1]] = '.'
  end

  private

  def load_current_map
    self.current_map = YAML.load(File.open(file)).split
  end

  def load_mobs
    mobs = []
    mob_positions.each { |pos| mobs << Mob.roll_new(self, pos) }
    self.mobs = mobs
  end

  def mob_positions
    mob_positions = []

    current_map.each do |line|
      line_num = current_map.index(line)
      line.split('').each_with_index.select { |c| mob_positions << [line_num, c[1]] if c[0] == 'm' }
    end
  end
end
