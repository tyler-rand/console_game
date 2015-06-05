# npc monster
class Mob
  attr_accessor :id, :name, :type, :level, :health, :max_health, :damage, :map, :movement_type

  #
  ## CLASS METHODS
  #

  def self.roll_new(zone)
    name   = 'welp'
    type   = 'typefsd'
    level  = zone.level
    damage = zone.level*2
    max_health = zone.level*10

    mob = Mob.new(name: name, type: type, level: level, damage: damage, max_health: max_health, map: zone, movement_type: 0)
    mob
  end

  #
  ## INSTANCE METHODS
  #

  def initialize(name:, type:, level:, max_health:, damage:, map:, movement_type:)
    @id            = object_id
    @name          = name
    @type          = type
    @level         = level
    @health        = max_health
    @max_health    = max_health
    @damage        = damage
    @map           = map
    @movement_type = movement_type
  end
end
