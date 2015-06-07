# npc monster
class Mob
  attr_accessor :id, :name, :type, :level, :health, :max_health, :damage, :map_id, :movement_type

  #
  ## CLASS METHODS
  #

  def self.roll_new(map)
    name   = 'welp'
    type   = 'typefsd'
    level  = map.level
    damage = map.level*2
    max_health = map.level*10

    mob = Mob.new(name: name, type: type, level: level, damage: damage, max_health: max_health, map_id: map.id, movement_type: 0)
    mob
  end

  #
  ## INSTANCE METHODS
  #

  def initialize(name:, type:, level:, max_health:, damage:, map_id:, movement_type:)
    @id            = object_id
    @name          = name
    @type          = type
    @level         = level
    @health        = max_health
    @max_health    = max_health
    @damage        = damage
    @map_id        = map_id
    @movement_type = movement_type
  end
end
