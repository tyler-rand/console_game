# map
class Map
  attr_accessor :id, :name, :level, :file, :current_map, :mobs, :vendors, :quests

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
    window.win.setpos(2, 2)
    window.win.addstr('---- MAPS ----')
    window.win.setpos(3, 2)

    Map.names.each do |map|
      window.win.addstr(map)
      window.win.setpos(window.win.cury + 1, 2)
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
    @vendors     = load_vendors
    @quests      = load_quests
  end

  def save
    File.open('db/MapsDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  def find_player
    current_map.each do |line|
      return [current_map.index(line), line.index('P')] if line.include?('P')
    end
  end

  def remove_at_loc(location)
    current_map[location[0]][location[1]] = '.'
  end

  private

  def load_current_map
    self.current_map = YAML.load(File.open(file)).split
  end

  def load_mobs
    mobs = []
    map_positions(Mob.map_character).each { |pos| mobs << Mob.roll_new(self, pos) }
    self.mobs = mobs
  end

  def load_vendors
    vendors = []
    map_positions(Vendor.map_character).each { |pos| vendors << Vendor.roll_new(self, pos) }
    self.vendors = vendors
  end

  def load_quests
    quests = []
    map_positions(Quest.map_character).each { |pos| quests << Quest.find(name, pos) }
    self.quests = quests
  end

  def map_positions(map_letter)
    positions = []

    current_map.each_with_index.map do |line, i|
      line.split('').each_with_index.select { |c| positions << [i, c[1]] if c[0] == map_letter }
    end

    positions
  end
end
