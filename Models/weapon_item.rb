# weapon subclass of item
class WeaponItem < Item
  attr_accessor :damage, :speed

  def initialize(args = {})
    super
    @damage = roll_damage
    @speed = roll_speed
  end

  private

  def roll_damage
    ((((50 + ilvl) * 2) - 90) * rand(0.85..1.15)).floor
  end

  def roll_speed
    rand(0.8..1.4).round(1)
  end
end
