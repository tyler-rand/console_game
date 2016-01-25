# npc monster
class Mob
  attr_accessor :id, :name, :type, :level, :health, :max_health, :damage, :defense, :map_id, :movement_type,
                :location

  #
  ## CLASS METHODS
  #

  def self.roll_new(map, location)
    name   = %w(terror vicious bloodthirsty).sample
    type   = %w(dragon zombie bear).sample
    damage = map.level * 2
    defense = map.level * 20
    max_health = map.level * 10

    mob = Mob.new(name: name, type: type, level: map.level, damage: damage, max_health: max_health,
                  defense: defense, map_id: map.id, movement_type: 0, location: location)
    mob
  end

  #
  ## INSTANCE METHODS
  #

  def initialize(options = {})
    @id            = object_id
    @name          = options[:name]
    @type          = options[:type]
    @level         = options[:level].to_i
    @health        = options[:max_health]
    @max_health    = options[:max_health]
    @damage        = options[:damage]
    @defense       = options[:defense]
    @map_id        = options[:map_id]
    @movement_type = options[:movement_type]
    @location      = options[:location]
  end
end
