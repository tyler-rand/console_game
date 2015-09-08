require_relative 'item'

# armor subclass of item
class ArmorItem < Item
  attr_accessor :armor

  def initialize(args = {})
    super
    @armor = roll_armor
  end

  # private

  def roll_armor
    ((((100 + ilvl) * 2) - 40) * (rand(0.5..2))).floor
  end
end
