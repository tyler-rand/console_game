# npc monster
class Mob
  attr_accessor :id, :name, :type, :level, :health, :max_health, :damage, :defense, :map_id,
                :movement_type, :location

  MAP_ICON = 'm'

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

  def initialize(name:, type:, level:, damage:, max_health:, defense:, map_id:, movement_type:,
                 location:)
    @id            = object_id
    @name          = name
    @type          = type
    @level         = level
    @health        = max_health
    @max_health    = max_health
    @damage        = damage
    @defense       = defense
    @map_id        = map_id
    @movement_type = movement_type
    @location      = location
  end
end
