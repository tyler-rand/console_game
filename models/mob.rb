# npc monster
class Mob
  attr_accessor :id, :name, :type, :level, :health, :max_health, :damage, :defense, :map_name,
                :movement_type, :location

  MAP_ICON = 'm'.freeze
  NAMED_MAP_ICON = 'M'.freeze
  NAME_PREFIX= %w(Bloodthirsy Rabid Feral Angry Dreadful Fearless Violent Massive).freeze
  NAME_SUFFIX = %w(Bear Zombie Werewolf Wolf Dragon Ape Ghoul Snake Lion Panther Shark).freeze
  TYPES = %w(Animal Undead Human).freeze

  def initialize(map:, location:, options: {})
    @id            = object_id
    @location      = location
    @name          = options[:name]  || NAME_PREFIX.sample + ' ' + NAME_SUFFIX.sample
    @type          = options[:type]  || TYPES.sample
    @level         = options[:level] || map.level
    @health        = options[:health] || map.level * 10
    @max_health    = options[:max_health] || map.level * 10
    @damage        = options[:damage] || map.level * 2
    @defense       = options[:defense] || map.level * 20
    @movement_type = options[:movement_type] || 0
    @map_name      = map || map.name
  end

  def self.load(map_name:, location:)
    mobs = YAML.load_stream(open('db/MobsDB.yml'))
    mobs.detect { |mob| mob.map_name == map_name && mob.location == location }
  end

  def save
    File.open('db/MobsDB.yml', 'a') { |f| f.write(to_yaml) }
  end
end
