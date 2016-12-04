# weapon subclass of item
class WeaponItem < Item
  attr_reader :damage, :speed

  def initialize(args = {}, damage: nil, speed: nil)
    super(args)
    @damage = damage ||= roll_damage
    @speed = speed ||= roll_speed
  end

  private

  def roll_damage
    ((((50 + ilvl) * 2) - 90) * rand(0.85..1.15)).floor
  end

  def roll_speed
    rand(0.8..1.4).round(1)
  end
end
