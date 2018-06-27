# npc monster
class Mob
  attr_reader :level, :location, :map, :map_name, :movement_type, :name, :type
  attr_accessor :health, :max_health, :damage, :defense

  MAP_ICON = 'm'.freeze
  NAMED_MAP_ICON = 'M'.freeze
  NAME_PREFIX = %w(Bloodthirsy Rabid Feral Angry Dreadful Fearless Violent Massive).freeze
  NAME_SUFFIX = %w(Bear Zombie Werewolf Wolf Dragon Ape Ghoul Snake Lion Panther Shark).freeze
  TYPES = %w(Animal Undead Human).freeze

  def initialize(map:, location:, options: {})
    @id            = object_id
    @map           = map
    @location      = location
    @name          = options[:name]  || default_name
    @type          = options[:type]  || default_type
    @level         = options[:level] || default_level
    @health        = options[:health] || default_health
    @max_health    = options[:max_health] || default_max_health
    @damage        = options[:damage] || default_damage
    @defense       = options[:defense] || default_defense
    @movement_type = options[:movement_type] || 0
    @map_name      = map
  end

  def self.find(map_name:, location:)
    mobs = YAML.load_stream(open('db/MobsDB.yml'))
    mobs.detect { |mob| mob.map_name == map_name && mob.location == location }
  end

  def save
    File.open('db/MobsDB.yml', 'a') { |f| f.write(to_yaml) }
  end

  private

  def default_name
    NAME_PREFIX.sample + ' ' + NAME_SUFFIX.sample
  end

  def default_type
    TYPES.sample
  end

  def default_level
    map.level
  end

  def default_health
    map.level * 10
  end

  def default_max_health
    map.level * 10
  end

  def default_damage
    map.level * 2
  end

  def default_defense
    map.level * 20
  end
end
