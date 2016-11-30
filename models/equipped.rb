# a player's equipped items
class Equipped
  attr_accessor :player, :weapon, :chest, :pants, :helm, :gloves, :boots

  def initialize(player:)
    @id     = object_id
    @player = player

    @weapon = nil
    @chest  = nil
    @pants  = nil
    @helm   = nil
    @gloves = nil
    @boots  = nil
  end

  def display(window)
    EquippedDisplayer.new(equipped: self, window: window).list
  end

  def calc_damage
    weapon ? (weapon.damage * weapon.speed).round(1) : 0
  end

  def calc_defense
    armors.inject(:+)
  end

  private

  def armors
    [
      chest ? chest.defense : 0,
      pants ? pants.defense : 0,
      helm ? helm.defense : 0,
      gloves ? gloves.defense : 0,
      boots ? boots.defense : 0
    ]
  end
end
